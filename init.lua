--- === Ki ===
---
--- Enable composable and modal macOS workflows, in the spirit of vi
---

local ki = {}
ki.__index = ki

ki.name = "Ki"
ki.version = "1.0.0"
ki.author = "Andrew Kwon"
ki.homepage = "https://github.com/andweeb/ki"
ki.license = "MIT - https://opensource.org/licenses/MIT"

local keyCodeMap = hs.keycodes.map

local modes = {
    normal = "normal",
    action = "action",
    entity = "entity",
    url = "url",
}

local function getScriptPath()
    return debug.getinfo(2, "S").source:sub(2):match("(.*/)")
end

local spoonPath = getScriptPath()
local machine = dofile(spoonPath.."/statemachine.lua")

--- Ki.state
--- Variable
---
--- The internal finite state machine that exposes transition events for use in event handlers.
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
    },
    entity = {
        { nil, "escape", function() ki.state:exitMode() end },
        { nil, "u", function() ki.state:enterUrlMode() end },
    },
    action = {
        { nil, "escape", function() ki.state:exitMode() end },
    },
    url = {
        { nil, "escape", function() ki.state:exitMode() end },
    },
}

-- Merge event triggers without overriding transition events
setmetatable(ki.transitions, {
    __add = function(lhs, rhs)
        local function areListsEqual(list1, list2)
            if #list1 ~= #list2 then return false end
            if #list1 == 0 and #list2 == 0 then return true end

            for _, value1 in pairs(list1) do
                local valueExists = false

                for _, value2 in pairs(list2) do
                    if value1 == value2 then
                        valueExists = true
                        break
                    end
                end

                if not valueExists then return false end
            end

            return true
        end

        for mode, events in pairs(rhs) do
            local transitionEvents = lhs[mode]
            local hotkeyMap = {}

            -- Map keyname to modifier keys list
            for _, transitionEvent in pairs(transitionEvents) do
                local eventModifiers = transitionEvent[EVENT_MODIFIERS_INDEX] or {}
                local eventKeyName = transitionEvent[EVENT_HOTKEY_INDEX]

                hotkeyMap[eventKeyName] = eventModifiers
            end

            for _, event in pairs(events) do
                -- Determine if event exists in transition events
                local eventModifiers = event[EVENT_MODIFIERS_INDEX] or {}
                local eventKeyName = event[EVENT_HOTKEY_INDEX]
                local eventTrigger = event[EVENT_TRIGGER_INDEX]

                if hotkeyMap[eventKeyName] and areListsEqual(hotkeyMap[eventKeyName], eventModifiers) then
                    local modifierName = ''

                    for index, modifiers in pairs(eventModifiers) do
                        modifierName = (index == 1 and modifierName or modifierName..'+')..modifiers
                    end

                    local binding = "{"..(#eventModifiers == 0 and '' or modifierName..'+')..eventKeyName.."}"

                    hs.showError("Cannot overwrite hotkey binding "..binding.." in "..mode.." mode reserved for transition events")
                else
                    table.insert(lhs[mode], event)
                end
            end
        end

        return lhs
    end
})

--- Ki.events
--- Variable
---
--- A table containing the definitions of non-transition workflow events.
---
--- With some event handlers
--- ```
--- local handleSafariEvent function(action)
---     if action then
---         -- Apply action to Safari (new tab, new private window, etc)
---     else
---         hs.application.open("Safari")
---     end
---     spoon.Ki.state:exitMode()
--- end
--- ```
--- an example configuration for the triggers would look like
--- ```
--- spoon.Ki.events = {
---       entity = {
---           none = {
---               s = handleSafariEvent,
---           },
---       },
---       url = {
---           none = {
---               g = handleGoogleUrlEvent,
---               r = handleRedditUrlEvent,
---           },
---       },
--- }
--- ```
ki.events = {
    entity = {
        { nil, "s", function(action)
            hs.application.launchOrFocus("Safari")

            local safari = hs.application.open("Safari", 1, true)

            if safari and action == "open" then
                safari:selectMenuItem("Open File...")
            elseif safari and action == "new" then
                safari:selectMenuItem("New Window")
            elseif safari and action == "new *" then
                safari:selectMenuItem("New Private Window")
            elseif safari and action == "tab" then
                safari:selectMenuItem("New Tab")
            elseif safari and action == "fullscreen" then
                safari:selectMenuItem("Enter Full Screen")
            end

            ki.state:exitMode()
        end },
    },
    action = {
        { nil, "f", function() ki.state:enterEntityMode("fullscreen", "f") end },
        { nil, "n", function() ki.state:enterEntityMode("new", "n") end },
        { nil, "o", function() ki.state:enterEntityMode("open", "o") end },
        { nil, "t", function() ki.state:enterEntityMode("tab", "t") end },
        { {"shift"}, "n", function() ki.state:enterEntityMode("new *", "n") end },
    },
    url = {
        { nil, "g", function() hs.urlevent.openURL("https://google.com") ki.state:exitMode() end },
    },
}

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

-- Initialize transition events, internal fsm, and event listener and callbacks
function ki:init()
    -- Transition events
    self.transitionEvents = {
        { name = "enterEntityMode", from = modes.normal, to = modes.entity },
        { name = "enterEntityMode", from = modes.action, to = modes.entity },
        { name = "enterActionMode", from = modes.normal, to = modes.action },
        { name = "enterUrlMode", from = modes.entity, to = modes.url },
        { name = "exitMode", from = modes.entity, to = modes.normal },
        { name = "exitMode", from = modes.url, to = modes.normal },
        { name = "exitMode", from = modes.action, to = modes.normal },
    }

    -- Create internal finite state machine
    self.state = machine.create({
        initial = modes.normal,
        events = self.transitionEvents,
        callbacks = (function()
            -- Initialize transition status display callbacks with mode transition events
            local callbacks = {}

            -- Add generic callback to record state transition trail from normal mode
            callbacks.onstatechange = function(self, event, prevState, nextState, action)
                -- Reset to normal mode or add event/action to breadcrumb trail
                if nextState == modes.normal then
                    ki.trail = { breadcrumb = {}, lastEvent = {} }
                else
                    table.insert(ki.trail.breadcrumb, { event = event, action = action })
                end
            end

            -- Set event callbacks
            for _, event in pairs(self.transitionEvents) do
                local eventName = "on"..event.name

                if not callbacks[eventName] then
                    callbacks[eventName] = function(self, event, prevState, nextState, action, key)
                        -- Save latest event
                        ki.trail.lastEvent = {
                            event = event,
                            action = action,
                        }

                        ki.statusDisplay:show(self.current, action)

                        print(event.." with action: <"..(action or "none")..">")
                    end
                end
            end

            return callbacks
        end)()
    })

    -- Set keydown listener and primary event handler function
    self.listener = hs.eventtap.new(
        { hs.eventtap.event.types.keyDown },
        function(event)
            local mode = self.state.current
            local events = self.triggers[mode]
            local action = self.trail.lastEvent.action
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

            -- Avoid propagating existing trigger or non-existent trigger in a non-normal mode
            if trigger then
                trigger(action)
                return true
            elseif mode ~= "normal" then
                hs.sound.getByName("Funk"):volume(1):play()
                return true
            end

            -- Propagate event in normal mode
        end
    )

end

function ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or dofile(spoonPath.."/status-display.lua")

    -- Set transition events and triggers
    ki.triggers = ki.transitions + ki.events

    -- Start keydown event listener
    self.listener:start()
end

return ki
