--- === Ki ===
---
--- Enable composable and modal macOS workflows in the spirit of vi
---

local ki = {}
ki.__index = ki

ki.name = "Ki"
ki.version = "1.0.0"
ki.author = "Andrew Kwon"
ki.homepage = "https://github.com/andweeb/ki"
ki.license = "MIT - https://opensource.org/licenses/MIT"

local keyCodeMap = hs.keycodes.map

local function getScriptPath()
    return debug.getinfo(2, "S").source:sub(2):match("(.*/)")
end

local spoonPath = getScriptPath()
local util = dofile(spoonPath.."/util.lua")
local machine = dofile(spoonPath.."/statemachine.lua")

--- Ki.state
--- Variable
---
--- The internal finite state machine for use in event definitions.
ki.state = {}

local EVENT_MODIFIERS_INDEX = 1
local EVENT_HOTKEY_INDEX = 2
local EVENT_TRIGGER_INDEX = 3
local EVENT_AUTOEXIT_INDEX = 4

--- Ki.transitions
--- Variable
---
--- A table containing the definitions of transition events.
ki.transitions = {
    normal = {
        { {"cmd"}, ";", function() ki.state:enterEntityMode() end },
        { {"cmd"}, "'", function() ki.state:enterActionMode() end },
        { {"cmd", "shift"}, ";", function() ki.state:enterUrlMode() end },
        { {"cmd", "shift"}, "'", function() ki.state:enterChooseMode() end },
    },
    entity = {
        { nil, "escape", function() ki.state:exitMode() end },
        { {"cmd", "shift"}, "'", function() ki.state:enterChooseMode() end },
    },
    action = {
        { nil, "escape", function() ki.state:exitMode() end },
    },
    choose = {
        { nil, "escape", function() ki.state:exitMode() end },
    },
    url = {
        { nil, "escape", function() ki.state:exitMode() end },
    },
}

--- Ki.states
--- Variable
---
--- A table containing the state events in the finite state machine.
ki.states = {
    { name = "enterEntityMode", from = "normal", to = "entity" },
    { name = "enterEntityMode", from = "action", to = "entity" },
    { name = "enterActionMode", from = "normal", to = "action" },
    { name = "enterChooseMode", from = "entity", to = "choose" },
    { name = "enterChooseMode", from = "normal", to = "choose" },
    { name = "enterUrlMode", from = "normal", to = "url" },
    { name = "exitMode", from = "entity", to = "normal" },
    { name = "exitMode", from = "url", to = "normal" },
    { name = "exitMode", from = "choose", to = "normal" },
    { name = "exitMode", from = "action", to = "normal" },
}

-- Merge Ki events with the option of overriding events
-- Events with conflicting hotkeys will result in the lhs event being overwritten by the rhs event
function ki:_mergeEvents(mode, lhs, rhs, overrideLHS)
    -- LHS event modifiers keyed by event keyname
    local lhsHotkeys = {}

    -- Map lhs keynames to modifier keys list
    for _, lhsEvent in pairs(lhs) do
        local eventModifiers = lhsEvent[EVENT_MODIFIERS_INDEX] or {}
        local eventKeyName = lhsEvent[EVENT_HOTKEY_INDEX]

        lhsHotkeys[eventKeyName] = eventModifiers
    end

    -- Merge events from rhs to lhs
    for _, rhsEvent in pairs(rhs) do
        -- Determine if event exists in lhs events
        local rhsEventModifiers = rhsEvent[EVENT_MODIFIERS_INDEX] or {}
        local eventKeyName = rhsEvent[EVENT_HOTKEY_INDEX]
        local eventTrigger = rhsEvent[EVENT_TRIGGER_INDEX]
        local hasHotkeyConflict = util:areListsEqual(lhsHotkeys[eventKeyName] , rhsEventModifiers)

        if not overrideLHS and hasHotkeyConflict then
            local modifierName = ""

            for index, modifiers in pairs(rhsEventModifiers) do
                modifierName = (index == 1 and modifierName or modifierName.."+")..modifiers
            end

            local binding = "{"..(#rhsEventModifiers == 0 and "" or modifierName.."+")..eventKeyName.."}"

            hs.showError("Cannot overwrite hotkey binding "..binding.." in "..mode.." mode reserved for transition events")
        else
            table.insert(lhs, rhsEvent)
        end
    end
end

-- Merge events under all modes
function ki:createEventsMetatable(overrideLHS)
    return {
        __add = function(lhs, rhs)
            for mode, events in pairs(rhs) do
                if not lhs[mode] then
                    hs.showError("Unexpected mode "..mode.." specified in custom events")
                else
                    self:_mergeEvents(mode, lhs[mode], events, overrideLHS)
                end
            end

            return lhs
        end,
    }
end

setmetatable(ki.transitions, ki:createEventsMetatable())

--- Ki.events
--- Variable
---
--- A table containing the definitions of non-transition workflow events under their respective mode names.
---
--- The following example initializes two url events to open google.com and reddit.com and a Safari entity event
--- ```
---     local function handleUrlEvent(url)
---         hs.urlevent.openURL(url)
---         spoon.Ki.state:exitMode()
---     end
---     local function handleSafariEvent()
---         hs.application.launchOrFocus("Safari")
---         spoon.Ki.state:exitMode()
---     end
---
---     spoon.Ki.events = {
---         url = {
---             { nil, "g", handleUrlEvent("https://google.com") },
---             { nil, "r", handleUrlEvent("https://reddit.com") },
---         },
---         entity = {
---             { nil, "s", handleSafariEvent },
---         },
---     }
--- ```
ki.events = {}

--- Ki:createEntityEvent(applicationName, eventHandler)
--- Method
--- Initializes an entity event to provide a handler with an `hs.application`, key name, and key flags
---
--- Parameters:
---  * applicationName - The application name for use in finding the `hs.application`
---  * eventHandler - A function that handles the entity event with the following arguments:
---   * app - The `hs.application` object of the provided application name
---   * keyName - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---   * flags - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
function ki:createEntityEvent(applicationName, eventHandler)
    local keyName = self.trail.lastEvent.keyName
    local flags = self.trail.lastEvent.flags
    local app = hs.application.get(applicationName) or hs.application.launchOrFocus(applicationName, 0.5)

    app = hs.appfinder.appFromName(applicationName)

    eventHandler(app, keyName, flags)

    self.state:exitMode()
end

--- Ki.statusDisplay
--- Variable
---
--- A table that defines the behavior for displaying the status on mode transitions. The `show` function should clear out any previous display and show the current transitioned mode with an action if available.
---  * `show` - A function invoked when a mode transition event occurs, with the following argument(s):
---    * `status` - a string value containing the current mode of the finite state machine (i.e., "normal", "entity", etc.)
---    * `key` - an optional char value of the key that triggered the state (i.e., "n", "N", etc.)
---
--- Defaults to a simple text display in the center of the menu bar of the focused screen.
ki.statusDisplay = nil

-- A list to store the breadcrumb trail of state transitions
ki.trail = {
    breadcrumb = {},
    lastEvent = {},
}

-- Automate the creation of finite state machine callbacks depending on the state events passed in
function ki:_createFsmCallbacks()
    local callbacks = {}

    -- Add generic state change callback for all events to record state transition trail from normal mode
    callbacks.onstatechange = function(_, eventName, _, nextState, flags, keyName)
        if nextState == "normal" then
            self.trail = { breadcrumb = {}, lastEvent = {} }
        else
            table.insert(self.trail.breadcrumb, {
                flags = flags,
                keyName = keyName,
                eventName = eventName,
            })
        end
    end

    -- Set event-specific callbacks for saving a breadcrumb trail of events and showing the status display
    for _, event in pairs(self.states) do
        local eventName = "on"..event.name

        if not callbacks[eventName] then
            callbacks[eventName] = function(fsm, _, _, _, flags, keyName)
                -- Save latest event
                self.trail.lastEvent = {
                    flags = flags,
                    keyName = keyName,
                    eventName = eventName,
                }

                self.statusDisplay:show(fsm.current, keyName)
            end
        end
    end

    return callbacks
end

-- Handle keydown event by triggering the appropriate event handler depending on the state and modifiers/keycode
function ki:_handleKeyDown(event)
    local mode = self.state.current
    local events = self.triggers[mode]
    local trigger = nil

    local flags = event:getFlags()
    local keyName = keyCodeMap[event:getKeyCode()]

    -- Determine event handler
    for _, event in pairs(events) do
        local eventModifiers = event[EVENT_MODIFIERS_INDEX] or {}
        local eventKeyName = event[EVENT_HOTKEY_INDEX]
        local eventTrigger = event[EVENT_TRIGGER_INDEX]
        local autoExitMode = event[EVENT_AUTOEXIT_INDEX]

        if flags:containExactly(eventModifiers) and keyName == eventKeyName then
            trigger = eventTrigger
        end
    end

    -- Automatically proxy action events to trigger entity mode to avoid unnecessary action event definitions
    if mode == "action" and not trigger then
        trigger = function(flags, keyName)
            ki.state:enterEntityMode(flags, keyName)
        end
    end

    -- Avoid propagating existing trigger or non-existent trigger in a non-normal mode
    if trigger then
        trigger(flags, keyName)
        return true
    elseif mode ~= "normal" then
        hs.sound.getByName("Funk"):volume(1):play()
        return true
    end

    -- Propagate event in normal mode
end

-- Initialize Ki transition events, internal finite state machine, and the principal event listener and its callbacks
function ki:init()
    -- Create internal finite state machine
    self.state = machine.create({
        initial = "normal",
        events = self.states,
        callbacks = self:_createFsmCallbacks()
    })

    -- Set keydown listener and primary event handler function
    local eventHandler = function(event)
        return self:_handleKeyDown(event)
    end
    self.listener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, eventHandler)
end

--- Ki:start()
--- Method
--- Sets the status display, transition events, and the default and custom keyboard events, and starts the keyboard event listener
---
--- Parameters:
---  * None
---
---  Returns:
---   * The `hs.eventtap` event tap object
function ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or dofile(spoonPath.."/status-display.lua")

    -- Initialize default events
    local defaultEvents = dofile(spoonPath.."/default-events.lua"):init(ki)
    setmetatable(defaultEvents, self:createEventsMetatable(true))

    -- Set transition events and triggers
    local triggers = defaultEvents + ki.events
    ki.triggers = ki.transitions + triggers

    -- Start keydown event listener
    return self.listener:start()
end

--- Ki:stop()
--- Method
--- Stops the keyboard event listener
---
--- Parameters:
---  * None
---
---  Returns:
---   * The `hs.eventtap` event tap object
function ki:stop()
    return self.listener:stop()
end

return ki
