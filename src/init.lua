--- === Ki ===
---
--- Composable, modal macOS automation inspired by the vi
---
--- Ki uses some particular terminology in its API and documentation:
--- * **_event/shortcut_** - a shortcut object containing the event handler and its keybinding. The object structure matches the argument list for hotkeys bindings in Hammerspoon: modifier keys, key name, and event handler function or entity object. For example, the following table represents an keydown event on `⇧⌘m`:
--- ```lua
--- local shortcuts = {
---     { { "shift", "cmd" }, "m", function() print("Pressed the `m` hotkey!") end },
---     { { "shift" }, "s", Ki.createEntity("Safari") },
--- }
--- ```
--- An entity object that implements a `dispatchAction` can be also used:
--- ```lua
--- local _, WordApplicationEntity = spoon.Ki.createEntity("Microsoft Word")
--- local _, ExcelApplicationEntity = spoon.Ki.createEntity("Microsoft Excel")
--- local shortcuts = {
---     { nil, "e", ExcelApplicationEntity },
---     { nil, "w", WordApplicationEntity },
--- }
--- ```
---
--- * **_state event_** - a table that defines a unidirectional link between two states in the finite state machine, or transitions between different modes. For example, the `enterEntityMode` state event allows the user to transition from `normal` mode to `entity` mode by calling `Ki.state:entityEntityMode`:
---  ```
---  local stateEvents = {
---      { name = "enterNormalMode", from = "desktop", to = "normal" },
---      { name = "enterEntityMode", from = "normal", to = "entity" },
---      { name = "exitMode", from = "entity", to = "desktop" },
---  }
---  ```
---
--- * **_transition event_** - a keydown event with a handler function that invokes a state change through the finite state machine. For example, the following transition events invoke fsm callbacks to allow the user to enter `entity` and `action` mode:
---  ```
---  { {"cmd"}, ";", function() Ki.state:enterEntityMode() end },
---  { {"cmd"}, "'", function() Ki.state:enterActionMode() end },
---  ```
---
--- * **_workflow_** - a list of transition and workflow events that execute a specific task, cycling from `desktop` mode back to `desktop` mode
---
--- * **_workflow event_** - a keydown event that's part of some workflow using the Hammerspoon API (i.e., event definitions in `default-workflows.lua`, or any event that is not a transition or state event)

local Ki = {}
Ki.__index = Ki

Ki.name = "Ki"
Ki.version = "1.0.0"
Ki.author = "Andrew Kwon"
Ki.homepage = "https://github.com/andweeb/ki"
Ki.license = "MIT - https://opensource.org/licenses/MIT"

local luaVersion = _VERSION:match("%d+%.%d+")

if not _G.getSpoonPath then
    function _G.getSpoonPath()
        return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
    end
end

local spoonPath = _G.getSpoonPath()
package.cpath = spoonPath.."/deps/lib/lua/"..luaVersion.."/?.so;"..package.cpath
package.path = spoonPath.."/deps/share/lua/"..luaVersion.."/?.lua;deps/share/lua/"..luaVersion.."/?/init.lua;"..package.path

-- luacov: disable
if not _G.requirePackage then
    function _G.requirePackage(name, isInternal)
        local location = not isInternal and "/deps/share/lua/"..luaVersion.."/" or "/"
        local packagePath = spoonPath..location..name..".lua"

        return dofile(packagePath)
    end
end
-- luacov: enable

local fsm = _G.requirePackage("fsm")
local util = _G.requirePackage("util", true)

local SHORTCUT_MODKEY_INDEX = 1
local SHORTCUT_HOTKEY_INDEX = 2
local SHORTCUT_EVENT_HANDLER_INDEX = 3

hs.application.enableSpotlightForNameSearches(true)

--- Ki.state
--- Variable
--- The internal [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki
Ki.state = {}

-- Create a metatable defined with state events operations
function Ki._createStatesMetatable()
    return {
        __add = function(lhs, rhs)
            for _, event in pairs(rhs) do
                table.insert(lhs, event)
            end

            return lhs
        end,
    }
end

-- Merge Ki events with the option of overriding events
-- Events with conflicting hotkeys will result in the lhs event being overwritten by the rhs event
function Ki._mergeEvents(mode, lhs, rhs, overrideLHS)
    -- LHS event modifiers keyed by event keyname
    local lhsHotkeys = {}

    -- Map lhs keynames to modifier keys
    for index, lhsEvent in pairs(lhs) do
        local modifiers = lhsEvent[SHORTCUT_MODKEY_INDEX] or {}
        local keyName = lhsEvent[SHORTCUT_HOTKEY_INDEX]

        lhsHotkeys[keyName] = {
            index = index,
            modifiers = modifiers,
        }
    end

    -- Merge events from rhs to lhs
    for _, rhsEvent in pairs(rhs) do
        -- Determine if event exists in lhs events
        local rhsEventModifiers = rhsEvent[SHORTCUT_MODKEY_INDEX] or {}
        local eventKeyName = rhsEvent[SHORTCUT_HOTKEY_INDEX]
        local eventModifiers = lhsHotkeys[eventKeyName] and lhsHotkeys[eventKeyName].modifiers or nil
        local hasHotkeyConflict = util.areListsEqual(eventModifiers, rhsEventModifiers)

        if not hasHotkeyConflict then
            table.insert(lhs, rhsEvent)
        else
            if overrideLHS then
                -- Overwrite LHS shortcut or concat the RHS shortcut
                local lhsIndex = lhsHotkeys[eventKeyName]
                    and lhsHotkeys[eventKeyName].index
                    or nil

                if lhsIndex ~= nil then
                    lhs[lhsIndex] = rhsEvent
                else
                    table.insert(lhs, rhsEvent)
                end
            else
                -- Generate hotkey binding text to display in console warning
                local modifierName = ""

                for index, modifiers in pairs(rhsEventModifiers) do
                    modifierName = (index == 1 and modifierName or modifierName.."+")..modifiers
                end

                local binding = "{"..(#rhsEventModifiers == 0 and "" or modifierName.."+")..eventKeyName.."}"

                hs.showError("Cannot overwrite hotkey binding "..binding.." in "..mode.." mode reserved for transition events")
            end
        end
    end
end

-- Create a metatable defined with transition or workflow events operations. An optional `overrideLHS` can be provided to enable overriding LHS events or show an error on conflicting hotkeys.
function Ki:_createEventsMetatable(overrideLHS)
    return {
        __add = function(lhs, rhs)
            for mode, events in pairs(rhs) do
                if not lhs[mode] then
                    lhs[mode] = {}
                end

                self._mergeEvents(mode, lhs[mode], events, overrideLHS)
            end

            return lhs
        end,
    }
end

--- Ki.transitions
--- Variable
--- A table containing the definitions of transition events.
---
--- The default mode transition events are defined:
---  * from `desktop` mode, <kbd>⌘⎋</kbd> to enter `normal` mode
---  * from `normal` mode, <kbd>⌘e</kbd> to enter `entity` mode
---  * from `normal` mode, <kbd>⌘a</kbd> to enter `action` mode
---  * from `normal` mode, <kbd>⌘s</kbd> to enter `select` mode
---  * from `normal` mode, <kbd>⌘u</kbd> to enter `url` mode
---  * from `normal` mode, <kbd>⌘v</kbd> to enter `volume` mode
---  * from `normal` mode, <kbd>⌘b</kbd> to enter `brightness` mode
---  * <kbd>⎋</kbd> to exit back to `desktop` mode from any of the modes above
---
--- The example transition events below allow transitions on specified keybindings to enter normal mode from desktop mode and exit back to desktop mode from normal mode:
---  ```
---  -- Initialize state events to expose `enterNormalMode` and `exitMode` methods on `Ki.state`
---  Ki.states = {
---      { name = "enterNormalMode", from = "desktop", to = "normal" },
---      { name = "exitMode", from = "normal", to = "desktop" },
---  }
---  local enterNormalMode = function() Ki.state:enterNormalMode() end
---  local exitMode = function() Ki.state:exitMode() end
---  Ki.transitions = {
---      desktop = {
---          { {"cmd"}, "escape", enterNormalMode, { "Desktop Mode", "Transition to Normal Mode" } },
---      },
---      normal = {
---          { nil, "escape", exitMode, { "Normal Mode", "Exit to Desktop Mode" } },
---      },
---  }
---  ```
---
--- **Note**: `action` mode is unique in that its events are generated at runtime and automatically dispatched to the intended `entity` handler. That's why there are no explicit transition events to `entity` mode defined in this default transitions table.
Ki.transitions = {}
Ki._defaultTransitions = {
    desktop = {
        {
            {"cmd"}, "escape",
            function(...) Ki.state:enterNormalMode(table.unpack({...})) end,
            { "Desktop Mode", "Transition to Normal Mode" },
        },
    },
    normal = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Normal Mode", "Exit to Desktop Mode" },
        },
        {
            {"cmd"}, "e",
            function(...) Ki.state:enterEntityMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to Entity Mode" },
        },
        {
            {"cmd"}, "a",
            function(...) Ki.state:enterActionMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to Action Mode" },
        },
        {
            {"cmd"}, "u",
            function(...) Ki.state:enterUrlMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to URL Mode" },
        },
        {
            {"cmd"}, "s",
            function(...) Ki.state:enterSelectMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to Select Mode" },
        },
        {
            {"cmd"}, "b",
            function(...) Ki.state:enterBrightnessControlMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to Brightness Control Mode" },
        },
        {
            {"cmd"}, "v",
            function(...) Ki.state:enterVolumeControlMode(table.unpack({...})) end,
            { "Normal Mode", "Transition to Volume Control Mode" },
        },
    },
    entity = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Entity Mode", "Exit to Normal Mode" },
        },
        {
            {"cmd"}, "s",
            function(...) Ki.state:enterSelectMode(table.unpack({...})) end,
            { "Entity Mode", "Transition to Select Mode" },
        },
    },
    action = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Action Mode", "Exit to Normal Mode" },
        },
        {
            nil, ".",
            function()
                local workflow = Ki.history.commands[#Ki.history.commands]
                Ki.state:exitMode()
                Ki:triggerWorkflow(workflow)
            end,
            { "Action Mode", "Repeat the last command" },
        },
    },
    select = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Select Mode", "Exit to Normal Mode" },
        },
    },
    url = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "URL Mode", "Exit to Normal Mode" },
        },
    },
    volume = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Volume Control Mode", "Exit to Normal Mode" },
        },
    },
    brightness = {
        {
            nil, "escape",
            function(...) Ki.state:exitMode(table.unpack({...})) end,
            { "Brightness Control Mode", "Exit to Normal Mode" },
        },
    },
}
setmetatable(Ki._defaultTransitions, Ki:_createEventsMetatable())

--- Ki.states
--- Variable
--- A table containing the [state events](https://github.com/unindented/lua-fsm#usage) for the finite state machine set to `Ki.state`. Custom state events can be set to `Ki.states` before calling `Ki.start()` to set up the FSM with custom transitions events.
---
--- The example state events below create methods on `Ki.state` to enter and exit entity mode from normal mode:
--- * `{ name = "enterEntityMode", from = "normal", to = "entity" }`
--- * `{ name = "exitMode", from = "entity", to = "normal" }`
---
--- **Note**: these events will only _create and expose_ methods on `Ki.state`. For example, the `Ki.state:enterEntityMode` and `Ki.state:exitMode` methods will only be initialized with the example state events above. These methods will need to be called in transition events ([`Ki.transitions`](#transitions)) in order to actually trigger the transition from mode to mode.
Ki.states = {}
Ki._defaultStates = {
    { name = "enterNormalMode", from = "desktop", to = "normal" },
    { name = "enterEntityMode", from = "normal", to = "entity" },
    { name = "enterEntityMode", from = "action", to = "entity" },
    { name = "enterActionMode", from = "normal", to = "action" },
    { name = "enterSelectMode", from = "entity", to = "select" },
    { name = "enterSelectMode", from = "normal", to = "select" },
    { name = "enterVolumeControlMode", from = "normal", to = "volume" },
    { name = "enterBrightnessControlMode", from = "normal", to = "brightness" },
    { name = "enterUrlMode", from = "normal", to = "url" },
    { name = "exitMode", from = "normal", to = "desktop" },
    { name = "exitMode", from = "entity", to = "desktop" },
    { name = "exitMode", from = "url", to = "desktop" },
    { name = "exitMode", from = "select", to = "desktop" },
    { name = "exitMode", from = "action", to = "desktop" },
    { name = "exitMode", from = "volume", to = "desktop" },
    { name = "exitMode", from = "brightness", to = "desktop" },
}
setmetatable(Ki._defaultStates, Ki._createStatesMetatable())

--- Ki.workflows
--- Variable
--- A table containing lists of workflow events keyed by mode name. The following example creates two entity and url events:
--- ```lua
--- local function handleUrlEvent(url)
---     hs.urlevent.openURL(url)
---     spoon.Ki.state:exitMode()
--- end
--- local function launchOrFocusApplicationEvent(appName)
---     hs.application.launchOrFocus(appName)
---     spoon.Ki.state:exitMode()
--- end
---
--- spoon.Ki.workflows = {
---     url = {
---         { nil, "g", function() handleUrlEvent("https://google.com") end },
---         { nil, "r", function() handleUrlEvent("https://reddit.com") end },
---     },
---     entity = {
---         { nil, "s", function() launchOrFocusApplicationEvent("Safari") end) },
---         { {"shift"}, "s", function() launchOrFocusApplicationEvent("Spotify") end) },
---     },
--- }
--- ```
Ki.workflows = {}

--- Ki.createEntity(subclassName) -> base Entity class[, subclassed Entity class]
--- Method
--- Returns the both the base and custom subclassed [entity class](Entity.html) for creating custom desktop entities
---
--- Parameters:
---  * None
---
--- Returns:
---   * The base `Entity` class
---   * A subclassed `ExtendedEntity` class if a `subclassName` is specified
function Ki.createEntity(subclassName)
    local Entity = _G.requirePackage("entity", true)
    local ExtendedEntity = subclassName and Entity:subclass(subclassName) or nil

    return Entity, ExtendedEntity
end

-- TODO
-- Ki:triggerWorkflow(event)
-- Method
-- A function that triggers a workflow (a series of events)
--
-- Parameters:
--  * `event` - A list of items describing an event with the following order:
--   * `app` - The `hs.application` object of the provided application name
--   * `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
--   * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
function Ki:triggerWorkflow(workflow)
    print(self, hs.inspect(workflow))
end

--- Ki.statusDisplay
--- Variable
--- A table that defines the behavior for displaying the status on mode transitions. The `show` function should clear out any previous display and show the current transitioned mode. The following methods should be available on the object:
---  * `show` - A function invoked when a mode transition event occurs, with the following arguments:
---    * `status` - A string value containing the current mode
---    * `parenthetical` - An optional char value of the key that triggered the state (i.e., "n", "N", etc.)
---
--- Defaults to a simple text display in the center of the menu bar of the focused screen.
Ki.statusDisplay = nil

-- A table that stores the `action`, `commands`, and `workflow` history of all state transitions. The `action` and `workflow` fields are cleared out and the `commands` stores the series of events (which make up the workflow) when the Ki mode transitions back to the initial state.
Ki.history = {
    action = {},
    commands = {},
    workflow = {
        events = {},
        triggers = {},
    },
}

function Ki.history:recordCommand(workflowEvents)
    -- TODO: Replace command history data structure with optimized fifo implementation for better item management
    if #self.commands > 100 then
        local lastCommand = self.commands[#self.commands]
        self.commands = { lastCommand }
    end

    table.insert(self.commands, workflowEvents)
end

function Ki.history:recordEvent(event)
    table.insert(self.workflow.events, event)
end

function Ki.history:resetCurrentWorkflow()
    self.action = {}
    self.workflow = {
        events = {},
        triggers = {},
    }
end

function Ki._renderHotkeyText(modifiers, keyName)
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
function Ki:_createFsmCallbacks()
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
        local parenthetical = eventName == "enterSelectMode" and next(Ki.history.action) and "with action" or actionHotkey

        -- Show the status display with the current mode and record the event to the workflow history
        self.statusDisplay:show(stateMachine.current, parenthetical)
        self.history:recordEvent(event)

        if nextState == "desktop" then
            self.history:recordCommand(self.history.workflow.events)
            self.history:resetCurrentWorkflow()
        end
    end

    return callbacks
end

-- Handle keydown event by triggering the appropriate event handler or entity action dispatcher depending on the mode, modifier keys, and keycode
function Ki:_handleKeyDown(event)
    local mode = self.state.current
    local workflowEvents = self.workflows[mode]
    local trigger = nil

    local flags = event:getFlags()
    local keyName = hs.keycodes.map[event:getKeyCode()]

    -- Determine event handler
    for _, workflowEvent in pairs(workflowEvents) do
        local eventModifiers = workflowEvent[SHORTCUT_MODKEY_INDEX] or {}
        local eventKeyName = workflowEvent[SHORTCUT_HOTKEY_INDEX]
        local eventTrigger = workflowEvent[SHORTCUT_EVENT_HANDLER_INDEX]

        if flags:containExactly(eventModifiers) and keyName == eventKeyName then
            trigger = eventTrigger
        end
    end

    -- Create action triggers at runtime to automatically enter entity mode with the intended event
    if mode == "action" and not trigger then
        trigger = function(actionFlags, actionKeyName)
            local action = {
                flags = actionFlags,
                keyName = actionKeyName,
            }

            Ki.history.action = action
            Ki.state:enterEntityMode(nil, nil, action)
        end
    end

    -- Avoid propagating existing trigger or non-existent trigger in a non-normal mode
    if trigger then
        if type(trigger) == "table" and trigger.dispatchAction then
            local shouldAutoExit = trigger:dispatchAction(mode, Ki.history.action)

            if shouldAutoExit then
                self.state:exitMode()
            end
        elseif type(trigger) == "function" then
            local shouldAutoExit = trigger(flags, keyName)

            if shouldAutoExit then
                self.state:exitMode()
            end
        else
            hs.showError("Unknown")
        end

        return true
    elseif mode ~= "desktop" then
        hs.sound.getByName("Funk"):volume(1):play()
        return true
    end

    -- Propagate event in normal mode
end

-- Primary init function to initialize the primary event handler
function Ki:init()
    local eventHandler = function(event)
        return self:_handleKeyDown(event)
    end

    -- Set keydown listener with the primary event handler
    self.listener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, eventHandler)
end

--- Ki:start() -> hs.eventtap
--- Method
--- Sets the status display, creates all transition and workflow events, and starts the input event listener
---
--- Parameters:
---  * None
---
--- Returns:
---   * An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object
function Ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or dofile(spoonPath.."/status-display.lua")

    -- Recreate the internal finite state machine if custom states are provided
    self.state = fsm.create({
        initial = "desktop",
        events = self._defaultStates + self.states,
        callbacks = self:_createFsmCallbacks()
    })

    -- Initialize default workflow events
    local defaultWorkflows = dofile(spoonPath.."/default-workflows.lua").init()
    setmetatable(defaultWorkflows, self:_createEventsMetatable(true))

    -- Set transition and workflow events
    local workflows = defaultWorkflows + self.workflows
    local transitions = self._defaultTransitions + self.transitions
    self.workflows = transitions + workflows

    -- Collect all actions
    local actions = {}
    for _, workflowActions in pairs(self.workflows) do
        for _, workflow in pairs(workflowActions) do
            table.insert(actions, workflow)
        end
    end

    -- Create Ki cheatsheet
    self.cheatsheet = _G.requirePackage("cheatsheet", true)

    -- Add cheatsheet entity into entity events
    table.insert(self.workflows.entity, {
        { "shift" }, "/",
        function() self.cheatsheet:show() return true end,
        { "Entities", "Cheatsheet" },
    })

    -- Initialize cheat sheet with both default and/or custom transition and workflow events
    local description = "Shortcuts for Ki modes, entities, and transition and workflow events"
    self.cheatsheet:init("Ki", description, actions)

    -- Start keydown event listener
    return self.listener:start()
end

--- Ki:stop() -> hs.eventtap
--- Method
--- Stops the input event listener
---
--- Parameters:
---  * None
---
--- Returns:
---   * An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object
function Ki:stop()
    return self.listener:stop()
end

return Ki
