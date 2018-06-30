--- === Ki ===
---
--- **Enable composable, modal commands to automate your Mac environment**
---
--- Here's a list of terms with definitions specific to this extension:
--- * **_event_** - a keydown event. The event object structure matches the argument list for hotkeys bindings in Hammerspoon: modifier keys, key name, and event handler function. For example, the following table represents an keydown event on `⇧⌘m`:
---  ```
---  { {"shift", "cmd"}, "m", handleEvent }
---  ```
---
--- * **_state event_** - a table that defines a unidirectional link between two states in the finite state machine. For example, the `enterEntityMode` state event allows the user to transition from `normal` mode to `entity` mode by calling `ki.state:entityEntityMode`:
---  ```
---  { name = "enterEntityMode", from = "normal", to = "entity" }
---  ```
---
--- * **_transition event_** - a keydown event with a handler function that invokes a state change through the finite state machine. For example, the following transition events invoke fsm callbacks to allow the user to enter `entity` and `action` mode:
---  ```
---  { {"cmd"}, ";", function() ki.state:enterEntityMode() end },
---  { {"cmd"}, "'", function() ki.state:enterActionMode() end },
---  ```
---
--- * **_workflow_** - a list of transition and workflow events that execute a specific task, cycling from `normal` mode back to `normal` mode
---
--- * **_workflow event_** - a keydown event that's part of some workflow using the Hammerspoon API (i.e., event definitions in `default-workflows.lua`, or any event that is not a transition or state event)

local ki = {}
ki.__index = ki

ki.name = "Ki"
ki.version = "1.0.0"
ki.author = "Andrew Kwon"
ki.homepage = "https://github.com/andweeb/ki"
ki.license = "MIT - https://opensource.org/licenses/MIT"

local luaVersion = _VERSION:match("%d+%.%d+")

local function getSpoonPath()
    return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
end

local spoonPath = getSpoonPath()
package.cpath = spoonPath.."/deps/lib/lua/"..luaVersion.."/?.so;"..package.cpath
package.path = spoonPath.."/deps/share/lua/"..luaVersion.."/?.lua;deps/share/lua/"..luaVersion.."/?/init.lua;"..package.path

local function requirePackage(name)
    local packagePath = spoonPath.."/deps/share/lua/"..luaVersion.."/"..name..".lua"

    return dofile(packagePath)
end

local fsm = requirePackage("fsm")
local util = dofile(spoonPath.."/util.lua")

--- Ki.state
--- Variable
--- The finite state machine implementation used to interface with predefined state events in transition event handlers.
ki.state = {}

local EVENT_MODIFIERS_INDEX = 1
local EVENT_HOTKEY_INDEX = 2
local EVENT_TRIGGER_INDEX = 3

--- Ki.transitions
--- Variable
--- A table containing the definitions of transition events. The following `normal` mode transition events are defined to enable the following transitions by default:
---  * `⌘;` to enter `entity` mode
---  * `⌘'` to enter `action` mode
---  * `⌘⇧;` to enter `url` mode
---  * `⌘⇧'` to enter `select` mode
---
--- Note: _`action` mode is special in that its transition events are generated at runtime, since hotkeys in `action` mode should be automatically dispatched to the intended `entity` handler. This is why there are no explicit transition events to `entity` mode defined in this default table (otherwise it would require manually defining every `action` event to transition to `entity` mode)._
ki.transitions = {
    normal = {
        { {"cmd"}, ";", function(...) ki.state:enterEntityMode(table.unpack({...})) end },
        { {"cmd"}, "'", function(...) ki.state:enterActionMode(table.unpack({...})) end },
        { {"cmd", "shift"}, ";", function(...) ki.state:enterUrlMode(table.unpack({...})) end },
        { {"cmd", "shift"}, "'", function(...) ki.state:enterSelectMode(table.unpack({...})) end },
    },
    entity = {
        { nil, "escape", function(...) ki.state:exitMode(table.unpack({...})) end },
        { {"cmd", "shift"}, "'", function(...) ki.state:enterSelectMode(table.unpack({...})) end },
    },
    action = {
        { nil, "escape", function(...) ki.state:exitMode(table.unpack({...})) end },
        { nil, ".", function()
            local workflow = ki.history.commands[#ki.history.commands]

            ki.state:exitMode()
            ki:triggerWorkflow(workflow)
        end },
    },
    url = {
        { nil, "escape", function(...) ki.state:exitMode(table.unpack({...})) end },
    },
    select = {
        { nil, "escape", function(...) ki.state:exitMode(table.unpack({...})) end },
    },
}

--- Ki.states
--- Variable
--- A table containing the state events in the finite state machine.
ki.states = {
    { name = "enterEntityMode", from = "normal", to = "entity" },
    { name = "enterEntityMode", from = "action", to = "entity" },
    { name = "enterActionMode", from = "normal", to = "action" },
    { name = "enterSelectMode", from = "entity", to = "select" },
    { name = "enterSelectMode", from = "normal", to = "select" },
    { name = "enterUrlMode", from = "normal", to = "url" },
    { name = "exitMode", from = "entity", to = "normal" },
    { name = "exitMode", from = "url", to = "normal" },
    { name = "exitMode", from = "select", to = "normal" },
    { name = "exitMode", from = "action", to = "normal" },
}

setmetatable(ki.states, {
    __add = function(lhs, rhs)
        for _, event in pairs(rhs) do
            table.insert(lhs, event)
        end

        return lhs
    end,
})

-- Merge Ki events with the option of overriding events
-- Events with conflicting hotkeys will result in the lhs event being overwritten by the rhs event
function ki._mergeEvents(mode, lhs, rhs, overrideLHS)
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
        local hasHotkeyConflict = util.areListsEqual(lhsHotkeys[eventKeyName] , rhsEventModifiers)

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

--- Ki:createEventsMetatable(overrideLHS)
--- Method
--- A function that creates a metatable defined with operations specific to Ki events. The metatable comes with the following operations:
---  * `__add` - Allow events to be added together, with errors on conflicting hotkeys if the override is disabled. In the case of a merge, the event in the first addend (the left item in the operation) will be overwritten with the second addend.
---    * For example, this metatable is set for `ki.transitions` with the functionality of overriding events disabled, since we wouldn't want to accidentally override any of the transition event hotkeys.
---
--- Parameters:
---  * `overrideLHS` - an optional boolean value to indicate whether to override events in an add operation
function ki:createEventsMetatable(overrideLHS)
    return {
        __add = function(lhs, rhs)
            for mode, events in pairs(rhs) do
                if not lhs[mode] then
                    hs.showError("Unexpected mode "..mode.." specified in custom events")
                else
                    self._mergeEvents(mode, lhs[mode], events, overrideLHS)
                end
            end

            return lhs
        end,
    }
end

setmetatable(ki.transitions, ki:createEventsMetatable())

--- Ki.workflows
--- Variable
--- A table containing lists of workflow events keyed by mode name. The following example creates two entity and url events:
--- ```
---     local function handleUrlEvent(url)
---         hs.urlevent.openURL(url)
---         spoon.Ki.state:exitMode()
---     end
---     local function handleApplicationEvent(appName)
---         hs.application.launchOrFocus(appName)
---         spoon.Ki.state:exitMode()
---     end
---
---     spoon.Ki.workflows = {
---         url = {
---             { nil, "g", function() handleUrlEvent("https://google.com") end },
---             { nil, "r", function() handleUrlEvent("https://reddit.com") end },
---         },
---         entity = {
---             { nil, "s", function() handleApplicationEvent("Safari") end) },
---             { {"shift"}, "s", function() handleApplicationEvent("Spotify") end) },
---         },
---     }
--- ```
ki.workflows = {}

--- Ki:createEntityEventHandler(applicationName, eventHandler)
--- Method
--- A helper function that invokes an event handler callback with the `hs.application` and keydown event information so event handlers are somewhat less boilerplate-y
---
--- Parameters:
---  * `applicationName` - The application name for use in finding the `hs.application`
---  * `eventHandler` - A callback function that handles the entity event with the following arguments:
---   * `app` - The `hs.application` object of the provided application name
---   * `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---   * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
function ki:createEntityEventHandler(applicationName, eventHandler)
    local app = hs.application.get(applicationName)

    if not app then
        hs.application.launchOrFocus(applicationName, 0.5)
        app = hs.appfinder.appFromName(applicationName)
    end

    eventHandler(app, self.history.action)

    self.state:exitMode()
end

--- Ki:triggerWorkflow(event)
--- Method
--- A function that triggers a workflow (a series of events)
---
--- Parameters:
---  * `event` - A list of items describing an event with the following order:
---   * `app` - The `hs.application` object of the provided application name
---   * `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---   * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
function ki:triggerWorkflow(workflow)
    -- TODO
    print(self, hs.inspect(workflow))
end

--- Ki.statusDisplay
--- Variable
--- A table that defines the behavior for displaying the status on mode transitions. The `show` function should clear out any previous display and show the current transitioned mode with an action if available.
---  * `show` - A function invoked when a mode transition event occurs, with the following argument(s):
---    * `status` - a string value containing the current mode of the finite state machine (i.e., "normal", "entity", etc.)
---    * `key` - an optional char value of the key that triggered the state (i.e., "n", "N", etc.)
---
--- Defaults to a simple text display in the center of the menu bar of the focused screen.
ki.statusDisplay = nil

--- Ki.history
--- Variable
--- A table that stores the `action`, `commands`, and `workflow` history of all state transitions. The `action` and `workflow` fields are cleared out and the `commands` stores the series of events (which make up the workflow) when the Ki mode transitions back to the initial state.
ki.history = {
    action = {},
    commands = {},
    workflow = {
        events = {},
        triggers = {},
    },
}

function ki.history:recordCommand(workflowEvents)
    -- TODO: Replace command history data structure with fifo implementation for better item management
    if #self.commands > 100 then
        local lastCommand = self.commands[#self.commands]
        self.commands = { lastCommand }
    end

    table.insert(self.commands, workflowEvents)
end

function ki.history:recordEvent(event)
    table.insert(self.workflow.events, event)
end

function ki.history:resetCurrentWorkflow()
    self.action = {}
    self.workflow = {
        events = {},
        triggers = {},
    }
end

-- Wrap the choice selection event handler to store the selection in the workflow history and refocus previous window
function ki:showSelectionModal(choices, selectEventHandler)
    local selectEvent = self.history.workflow.events[#self.history.workflow.events]
    local modal = hs.chooser.new(function(choice)
        selectEvent.choice = choice
        selectEventHandler(choice)
    end)

    modal:choices(choices)
    modal:bgDark(true)

    modal:show()
end

function ki._renderHotkeyText(modifiers, keyName)
    local modKeyText = ""
    local modNames = {
        cmd = "⌘",
        alt = "⌥",
        shift = "⇧",
        ctrl = "⌃",
        fn = "<fn>",
    }

    for name, isKeyDown in pairs(modifiers) do
        if name and modNames[name] and isKeyDown then
            modKeyText = modKeyText..modNames[name]
        end
    end

    return modKeyText..keyName
end

-- Generate the finite state machine callbacks for all state events, generic `onstatechange` callbacks for recording/resetting event history and state event-specific callbacks
function ki:_createFsmCallbacks()
    local callbacks = {}

    -- Add generic state change callback for all events to record and reset workflow event history
    callbacks.on_enter_state = function(_, eventName, _, nextState, stateMachine, flags, keyName, action)
        if not self.listener or not self.listener:isEnabled() then
            return
        end

        local event = {
            flags = flags,
            action = action,
            keyName = keyName,
            eventName = eventName,
        }
        local actionHotkey = action and self._renderHotkeyText(action.flags, action.keyName)
        local parenthetical = eventName == "enterSelectMode" and next(ki.history.action) and "with action" or actionHotkey

        -- Show the status display with the current mode and record the event to the workflow history
        self.statusDisplay:show(stateMachine.current, parenthetical)
        self.history:recordEvent(event)

        if nextState == "normal" then
            self.history:recordCommand(self.history.workflow.events)
            self.history:resetCurrentWorkflow()
        end
    end

    return callbacks
end

-- Handle keydown event by triggering the appropriate event handler depending on the state and modifiers/keycode
function ki:_handleKeyDown(event)
    local mode = self.state.current
    local workflowEvents = self.workflows[mode]
    local trigger = nil

    local flags = event:getFlags()
    local keyName = hs.keycodes.map[event:getKeyCode()]

    -- Determine event handler
    for _, workflowEvent in pairs(workflowEvents) do
        local eventModifiers = workflowEvent[EVENT_MODIFIERS_INDEX] or {}
        local eventKeyName = workflowEvent[EVENT_HOTKEY_INDEX]
        local eventTrigger = workflowEvent[EVENT_TRIGGER_INDEX]

        if flags:containExactly(eventModifiers) and keyName == eventKeyName then
            trigger = eventTrigger
        end
    end

    -- Create action triggers at runtime to automatically enter entity mode with the intended event
    if mode == "action" and not trigger then
        trigger = function(entityFlags, entityKeyName)
            local action = {
                flags = entityFlags,
                keyName = entityKeyName,
            }

            ki.history.action = action
            ki.state:enterEntityMode(nil, nil, action)
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

-- Initialize finite state machine and event listener
function ki:init()
    local eventHandler = function(event)
        return self:_handleKeyDown(event)
    end

    -- Create internal finite state machine
    self.state = fsm.create({
        initial = "normal",
        events = self.states,
        callbacks = self:_createFsmCallbacks()
    })

    -- Set keydown listener with the primary event handler
    self.listener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, eventHandler)
end

--- Ki:start()
--- Method
--- Sets the status display, initializes transition and workflow events, and starts the keyboard event listener
---
--- Parameters:
---  * None
---
--- Returns:
---   * The `hs.eventtap` object
function ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or dofile(spoonPath.."/status-display.lua")

    -- Initialize default workflow events
    local defaultEvents = dofile(spoonPath.."/default-workflows.lua"):init(ki)
    setmetatable(defaultEvents, self:createEventsMetatable(true))

    -- Set transition and workflow events
    local workflows = defaultEvents + ki.workflows
    ki.workflows = ki.transitions + workflows

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
--- Returns:
---   * The `hs.eventtap` object
function ki:stop()
    return self.listener:stop()
end

return ki
