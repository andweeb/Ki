--- === Ki ===
---
--- > A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.
---
--- ### Intro
---
--- Ki follows a [modal paradigm](http://vimcasts.org/episodes/modal-editing-undo-redo-and-repeat): as you would edit text objects with operators in vi, you would automate entities with actions in Ki.
---
--- Ki provides an API for configuring custom modes and keyboard shortcuts to allow for the automation of any "entity", such as applications, files, websites, windows, smart devices, basically anything that can be programmatically controlled on macOS.
---
--- Ki ships with the following core modes:
--- * `DESKTOP` the default state of macOS
--- * `NORMAL` a mode in which modes can be entered or actions can be specified
--- * `ENTITY` a mode in which entities are available to be launched or activated
---
--- #### Shortcut Structure
---
--- The shortcut table structure is similar to the argument list for binding hotkeys in Hammerspoon:
---   1. a list of [modifier keys](http://www.hammerspoon.org/docs/hs.hotkey.html#bind) or `nil`
---   2. a string containing the name of a keyboard key (as found in [hs.keycodes.map](http://www.hammerspoon.org/docs/hs.keycodes.html#map))
---   3. the event handler which can be one of the following values:
---      * a function that takes in no arguments
---      * an [`Entity`](#Entity) instance (or subclassed entity instance) that implements a [`dispatchAction`](Entity.html#dispatchAction) method to be invoked when the hotkey is pressed.
---
---      A boolean return value will tell Ki to automatically exit back to `desktop` mode after the action has completed.
---   4. a tuple containing metadata about the shortcut: name of the shortcut category and description of the shortcut to be displayed in the cheatsheet
---
--- ```
--- -- Example shortcut list:
--- {
---     { nil, "t", function() print("executed action") end, { "Test", "Test print to console" } },
---     { { "cmd", "shift" }, "s", Ki.Application:new("Slack"), { "Entities", "Slack" } },
--- }
---
--- -- Explanation:
--- {
---      {
---          nil,                                     -- assign hotkey with no modifier key
---          "t",                                     -- assign the "t" key
---          function() print("executed action") end, -- event handler function
---          { "Test", "Test print to console" }      -- shortcut metadata
---      },
---      {
---          { "cmd", "shift" },                      -- assign the command and shift modifier keys
---          "s",                                     -- assign the "s" key
---          Ki.Application:new("Slack"),             -- initialized Application instance
---          { "Entities", "Slack" },                 -- shortcut metadata
---      },
--- }
--- ```

local Ki = {}
Ki.__index = Ki

Ki.name = "Ki"
Ki.version = "1.6.4"
Ki.author = "Andrew Kwon"
Ki.homepage = "https://github.com/andweeb/ki"
Ki.license = "MIT - https://opensource.org/licenses/MIT"

local spoonPath = hs.spoons.scriptPath()
local luaVersion = _VERSION:match("%d+%.%d+")

package.path = package.path..";"..spoonPath.."?.lua"
package.path = spoonPath.."/deps/share/lua/"..luaVersion.."/?.lua;deps/share/lua/"..luaVersion.."/?/init.lua;"..package.path

_G.SHORTCUT_MODKEY_INDEX = 1
_G.SHORTCUT_HOTKEY_INDEX = 2
_G.SHORTCUT_EVENT_HANDLER_INDEX = 3
_G.SHORTCUT_NAME_INDEX = 4

local FSM = require("fsm")
local Cheatsheet = require("cheatsheet")

-- Allow Spotlight to be used to find alternate names for applications
hs.application.enableSpotlightForNameSearches(true)

--- Ki.Entity
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some generic automatable desktop entity. Class methods and properties are documented [here](Entity.html).
Ki.Entity = require("entity")

--- Ki.Application
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that subclasses [Entity](Entity.html) to represent some automatable desktop application. Class methods and properties are documented [here](Application.html).
Ki.Application = require("application")

--- Ki.File
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some file or directory at an existing file path. Class methods and properties are documented [here](File.html).
Ki.File = require("file")

--- Ki.Website
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some website. Class methods and properties are documented [here](Website.html).
Ki.Website = require("website")

--- Ki.ApplicationWatcher
--- Constant
--- A module that wraps [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) to track application states. Methods and properties are documented [here](ApplicationWatcher.html).
Ki.ApplicationWatcher = require("application-watcher")

--- Ki.state
--- Constant
--- The [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki.
Ki.state = {}

--- Ki.defaultEntities
--- Variable
--- A table containing lists of all default entity instances keyed by mode name when the [default config](#useDefaultConfig) is used, `nil` otherwise.
Ki.defaultEntities = nil

function Ki.getLocalVariables(variableType)
    local index = 1
    local variables = {}

    while true do
        local name, value = debug.getlocal(2, index)

        if name ~= nil and name ~= "(*temporary)" then
            if type(value) == variableType then
                variables[name] = value
            end
        else
            break
        end

        index = index + 1
    end

    return variables
end

-- Create a string shortcut key from its modifiers and hotkey
function Ki.getShortcutKey(modifiers, hotkey)
    if not hotkey or not modifiers then
        return tostring(hotkey)
    end

    local clonedModifiers = {table.unpack(modifiers)}
    table.sort(clonedModifiers)

    return table.concat(clonedModifiers)..hotkey
end

-- Merge Ki shortcuts with the option of overriding shortcuts. Shortcuts with conflicting hotkeys
-- will result in the lhs shortcut being overwritten by the rhs shortcut
function Ki:mergeShortcuts(fromList, toList)
    fromList = fromList or {}
    toList = toList or {}

    local mergedShortcuts = {}

    -- Memoize `fromList` hotkeys for reference when iterating on `toList`
    local memo = {}
    for key, value in pairs(fromList) do
        if type(key) == "string" and #value > 0 then
            local categoryName = key
            local categorizedShortcuts = value
            for _, shortcut in pairs(categorizedShortcuts) do
                local memoKey = self.getShortcutKey(table.unpack(shortcut))
                memo[memoKey] = { shortcut, categoryName }
            end
        else
            local shortcut = value
            local memoKey = self.getShortcutKey(table.unpack(shortcut))
            memo[memoKey] = { shortcut }
        end
    end

    -- Insert `toList` shortcuts into `mergedShortcuts` that overlap with `fromList`
    for key, value in pairs(toList) do
        if type(key) == "string" and #value > 0 then
            local categoryName = key
            local categorizedShortcuts = value

            for _, shortcut in pairs(categorizedShortcuts) do
                local memoKey = self.getShortcutKey(table.unpack(shortcut))
                local foundShortcut, foundCategoryName = table.unpack(memo[memoKey] or {})

                if foundShortcut then
                    if foundCategoryName then
                        mergedShortcuts[foundCategoryName] = mergedShortcuts[foundCategoryName] or {}
                        table.insert(mergedShortcuts[foundCategoryName], foundShortcut)
                    else
                        table.insert(mergedShortcuts, foundShortcut)
                    end
                else
                    if categoryName then
                        mergedShortcuts[categoryName] = mergedShortcuts[categoryName] or {}
                        table.insert(mergedShortcuts[categoryName], shortcut)
                    else
                        table.insert(mergedShortcuts, shortcut)
                    end
                end

                memo[memoKey] = nil
            end
        else
            local shortcut = value
            local memoKey = self.getShortcutKey(table.unpack(shortcut))
            local foundShortcut, categoryName = table.unpack(memo[memoKey] or {})

            if foundShortcut then
                if categoryName then
                    mergedShortcuts[categoryName] = mergedShortcuts[categoryName] or {}
                    table.insert(mergedShortcuts[categoryName], foundShortcut)
                else
                    table.insert(mergedShortcuts, foundShortcut)
                end
            else
                table.insert(mergedShortcuts, shortcut)
            end

            memo[memoKey] = nil
        end
    end

    -- Add any remaining memoized shortcuts to `mergedShortcuts` not in `toList`
    for _, memoized in pairs(memo) do
        local shortcut, categoryName = table.unpack(memoized)

        if categoryName then
            mergedShortcuts[categoryName] = mergedShortcuts[categoryName] or {}
            table.insert(mergedShortcuts[categoryName], shortcut)
        else
            table.insert(mergedShortcuts, shortcut)
        end
    end

    return mergedShortcuts
end

-- A table containing [state transition events](https://github.com/unindented/lua-fsm#usage) that
-- allow transitions between different modes in Ki.
Ki.modeTransitionEvents = {
    -- NORMAL --
    { name = "enterNormalMode", from = "desktop", to = "normal" },
    { name = "exitMode", from = "normal", to = "desktop" },
}

-- A table containing lists of shortcuts keyed by mode name.
Ki.shortcuts = {
    desktop = {
        { {"cmd"}, "escape", function() Ki.state:enterNormalMode() end, "Enter Normal Mode" },
    },
    normal = {
        { nil, "escape", function() Ki.state:exitMode() end, "Exit to Desktop Mode" },
    },
}

--- Ki.modeIndicator
--- Variable
--- A module that defines the behavior for displaying the current mode. The `show` function should reset the previous display and show the current transitioned mode. The following methods should be available on the object:
---  * `show` - A function invoked when a mode transition event occurs, with the following arguments:
---    * `mode - A string value containing the name of the current mode
---    * `action` - An action if specified in the executed workflow, `nil` otherwise
---
--- Defaults to an implementation that displays the mode as a menubar item.
Ki.modeIndicator = nil

-- A table that stores the workflow history
Ki.history = {
    workflow = {},
    action = {},
}

Ki.modes = {}

function Ki.history:recordEvent(mode, keyName, flags)
    table.insert(self.workflow, {
        mode = mode,
        flags = flags,
        keyName = keyName,
    })
end

-- Generate the finite state machine callbacks for all state events, generic `onstatechange`
-- callbacks for recording/resetting event history and state event-specific callbacks
function Ki:_createFsmCallbacks()
    local callbacks = {}

    -- Add generic state change callback for all events to record and reset workflow event history
    callbacks.on_enter_state = function(_, _, _, nextState, stateMachine)
        if not self.listener or not self.listener:isEnabled() then
            return
        end

        -- Update the current mode in the mode indicator
        self.modeIndicator:show(stateMachine.current, self.history.action)

        -- Record the event to the workflow history
        if nextState == "desktop" then
            self.history.workflow = {}
            self.history.action = {}
        end
    end

    return callbacks
end

-- Handle keydown event by triggering the appropriate event handler or entity action dispatcher
-- depending on the mode, modifier keys, and keycode
function Ki:_handleKeyDown(event)
    local mode = self.state.current
    local shortcuts = self.shortcuts[mode]
    local handler = nil

    local flags = event:getFlags()
    local keyName = hs.keycodes.map[event:getKeyCode()]

    -- Determine event handler
    for _, shortcut in pairs(shortcuts) do
        local eventModifiers = shortcut[_G.SHORTCUT_MODKEY_INDEX] or {}
        local eventKeyName = shortcut[_G.SHORTCUT_HOTKEY_INDEX]
        local eventTrigger = shortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]

        if flags:containExactly(eventModifiers) and keyName == eventKeyName then
            handler = eventTrigger
        end
    end

    -- Create action handlers at runtime to automatically enter entity mode with the intended event
    if mode == "normal" and not handler then
        handler = function(actionFlags, actionKeyName)
            local action = {
                flags = actionFlags,
                keyName = actionKeyName,
            }

            self.history.action = action
            self.state:enterEntityMode(_, _, action)
        end
    end

    -- Avoid propagating existing handler or non-existent handler in any mode besides normal mode
    if handler then
        self.history:recordEvent(mode, keyName, flags)

        if type(handler) == "table" and handler.dispatchAction then
            local shouldAutoExit = handler:dispatchAction(mode, self.history.action, self.history.workflow)

            if shouldAutoExit then
                self.state:exitMode()
            end
        elseif type(handler) == "function" then
            local shouldAutoExit = handler(flags, keyName)

            if shouldAutoExit then
                self.state:exitMode()
            end
        end

        return true
    elseif mode ~= "desktop" then
        hs.sound.getByName("Funk"):volume(1):play()
        return true
    end

    -- Propagate event when there is no handler in desktop mode
end

-- Primary init function to initialize the primary event handler
function Ki:init()
    -- Set keydown listener with the primary event handler
    local eventHandler = function(event) return self:_handleKeyDown(event) end
    self.listener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, eventHandler)
end

--- Ki:Mode(mode, enterModeShortcut, shortcuts) -> table of state transition events, table of registered shortcuts
--- Method
--- Registers a new custom mode and its keyboard shortcuts.
---
--- Parameters:
---  * `mode` - The name of the new mode to be registered
---  * `enterModeShortcut` - The shortcut that will be available in normal mode to enter the new custom mode
---
---  The shortcut follows the same table structure as any other shortcut, except the event handler function is optional, but if not `nil` will be invoked after the mode has been entered with the following arguments:
---    * `fsm` - The [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki
---    * `fromMode` - The previous mode name
---    * `toMode` - The current mode name
---
---  Example of `enterModeShortcut` table:
---  ```lua
---  {
---      {"cmd"}, "f",
---      function(fsm, fromMode, toMode)
---          print("Current state of the FSM is "..fsm.current) -- (should equal `toMode`)
---          print("Transitioned from "..fromMode.." to "..toMode)
---      end,
---      { "Normal Mode", "Enter File Mode" },
---  },
---  ```
---  * `shortcuts` - The shortcuts that will be assigned to the new custom mode
function Ki:Mode(options)
    local name = options.name
    local actions = options.actions
    local shortcut = options.shortcut
    local shortcuts = options.shortcuts

    if self.modes[name] then
        self:registerModeShortcuts(name, shortcuts)
        return
    end

    self.modes[name] = actions or true

    -- Register the action to enter the mode from normal mode
    self:registerModeTransition("normal", name, shortcut)

    -- Register the action to exit the mode back to desktop mode
    local exitModeShortcut = { nil, "escape", nil, "Exit to Desktop Mode" }
    self:registerModeTransition(name, "desktop", exitModeShortcut, "exitMode")

    -- Register the new mode shortcuts
    self:registerModeShortcuts(name, shortcuts)
end

function Ki:ModeTransition(transition)
    local fromMode, toMode, transitionModeShortcut

    if #transition > 0 then
        fromMode, toMode, transitionModeShortcut = table.unpack(transition)
    else
        fromMode = transition.from
        toMode = transition.to
        transitionModeShortcut = transition.shortcut
    end

    self:registerModeTransition(fromMode, toMode, transitionModeShortcut)
end

function Ki:ModeTransitions(transitionList)
    for i = 1, #transitionList do
        self:ModeTransition(transitionList[i])
    end
end

--- Ki:registerModeTransition(fromMode, toMode, transitionModeShortcut[, transitionName]) -> table of state transition events, table of registered shortcuts
--- Method
--- Allows a transition between two modes and registers the shortcut in normal mode to transition to the target mode
---
--- Parameters:
---  * `fromMode` - The name of the starting mode that will have the transition shortcut assigned to
---  * `toMode` - The name of the target mode that will be transitioned to from the `fromMode` mode
---  * `transitionModeShortcut` - The shortcut to be assigned to the `fromMode` to transition to the `toMode`
---  * `transitionName` - An optional name for the transition method to be made available on [`Ki.state`](Ki.html#state). Defaults to "enter?Mode", ? being the capitalized mode name.
---
---  The transition mode shortcut follows the same table structure as any other shortcut, except the third list item is an optional callback to be invoked after the mode has been entered:
---  ```lua
---  {
---      {"cmd"}, "f",
---      function(fsm, fromMode, toMode)
---          print("Current state of the FSM is "..fsm.current) -- should equal `toMode`
---          print("Transitioned from "..fromMode.." to "..toMode)
---      end,
---      { "Normal Mode", "Enter File Mode" },
---  },
---  ```
function Ki:registerModeTransition(fromMode, toMode, transitionModeShortcut, transitionName)
    transitionName = transitionName or "enter"..toMode:gsub("^%l", string.upper).."Mode"

    local stateEvent = {
        name = transitionName,
        from = fromMode,
        to = toMode,
    }

    -- Add to mode transition events
    table.insert(self.modeTransitionEvents, stateEvent)

    -- Compose the transition mode transition event handler with the transition callback
    local onTransition = transitionModeShortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]
    transitionModeShortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX] = function()
        self.state[transitionName](self.state)
        if onTransition then
            onTransition(self.state, fromMode, toMode)
        end
    end

    -- Dynamically enter create transition shortcut name
    if not transitionModeShortcut[_G.SHORTCUT_NAME_INDEX] then
        transitionModeShortcut[_G.SHORTCUT_NAME_INDEX] = "Enter "..toMode:gsub("^%l", string.upper).." Mode"
    end

    -- Register shortcut mode transition shortcut
    return self.modeTransitionEvents, self:registerModeShortcuts(fromMode, { transitionModeShortcut })
end

--- Ki:registerModeShortcuts(mode, shortcuts) -> table of registered shortcuts
--- Method
--- Registers a set of shortcuts for a mode that is already registered.
---
--- Parameters:
---  * `mode` - The name of the mode
---  * `shortcuts` - A list of shortcuts
---
--- Returns:
---   * The total list of shortcuts registered for the given mode
function Ki:registerModeShortcuts(mode, shortcuts)
    local modeShortcuts = self.shortcuts[mode] or {}
    self.shortcuts[mode] = self:mergeShortcuts(shortcuts, modeShortcuts)
    return self.shortcuts[mode]
end

--- Ki:remapShortcuts(shortcuts) -> table of categorized shortcut mappings
--- Method
--- Remaps a categorized set of shortcuts, each matching the argument list for [hotkey bindings](https://www.hammerspoon.org/docs/hs.hotkey.html#bind) in Hammerspoon: modifier keys list and key name (i.e. `{ {"cmd", "shift"}, "s" }`).
---
--- The remapped shortcuts table can be constructed as either:
--- * a mapping of the shortcut descriptions to hotkeys keyed by category name (as shown in the cheatsheet)
--- ```lua
--- {
---     -- Remap the following application shortcuts using their metadata
---     -- { { "shift" }, "s", entities.Spotify, { "Entities", "Spotify" } },
---     -- { nil, "g", entities.GoogleChrome, { "Entities", "Google Chrome" } },
---     Entities = {
---         Spotify = { nil, "s" },
---         ["Google Chrome"] = { {"cmd", "shift"}, "g" },
---     },
---     -- Remap the following website mode shortcuts using their metadata
---     -- { nil, "f", websites.Facebook, { "Websites", "Facebook" } },
---     -- { nil, "m", websites.Messenger, { "Websites", "Facebook Messenger" } },
---     ["Websites"] = {
---         Facebook = { { "shift" }, "f" },
---         ["Facebook Messenger"] = { { "shift" }, "m" },
---     },
--- }
--- ```
---
--- * a mapping of entity names to hotkeys keyed by mode name
--- ```lua
--- {
---     -- Remap the following application entities available in entity mode:
---     -- Ki.defaultEntities.entity.Spotify.name == "Spotify"
---     -- Ki.defaultEntities.entity.GoogleChrome.name == "Google Chrome"
---     entity = {
---         Spotify = { nil, "s" },
---         ["Google Chrome"] = { {"cmd", "shift"}, "g" },
---     },
---     -- Remap the following website entities available in website mode:
---     -- Ki.defaultEntities.website.Facebook.name == "https://facebook.com"
---     -- Ki.defaultEntities.website.Messenger.name == "https://messenger.com"
---     website = {
---         ["https://facebook.com"] = { {"shift"}, "f" },
---         ["https://messenger.com"] = { {"shift"}, "m" },
---     },
--- }
--- ```
---
--- Note: if a shortcut is already in use in a given mode or category, it will need to be manually remapped to a different unused shortcut, or unmapped using a `{ unmap = true }` value
--- ```lua
--- {
---     -- Remap the following application entities available in entity mode:
---     entity = {
---        Spotify = { nil, "s" },     -- assign the registered Safari shortcut to Spotify
---        Safari = { unmap = true },  -- unmap Safari's shortcut since it conflicts with Spotify now
---     },
--- }
--- ```
---
--- Parameters:
---  * `shortcuts` - A set of shortcuts categorized by either the shortcut category and description (used in the cheatsheet) or by mode and entity name
function Ki:remapShortcuts(remappedShortcuts)
    local memo = {}
    for _, remapped in pairs(remappedShortcuts) do
        local key = remapped.mode.."."..remapped.name
        memo[key] = remapped.shortcut
    end

    -- Iterate through modal shortcuts to remap
    for mode, modeShortcuts in pairs(self.shortcuts) do
        for _, shortcut in pairs(modeShortcuts) do
            local handler = shortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]
            local name = shortcut[_G.SHORTCUT_NAME_INDEX]

            if not name and type(handler) == "table" then
                name = handler.name
            end

            local key = mode.."."..name

            if memo[key] then
                local remappedShortcut = memo[key]
                shortcut[_G.SHORTCUT_MODKEY_INDEX] = remappedShortcut[_G.SHORTCUT_MODKEY_INDEX]
                shortcut[_G.SHORTCUT_HOTKEY_INDEX] = remappedShortcut[_G.SHORTCUT_HOTKEY_INDEX]
            end
        end
    end
end

--- Ki:useDefaultConfig([options])
--- Method
--- Loads the default config
---
--- The default config initializes and assigns preset keybindings for almost all native macOS applications, common directory files, and popular websites, and achieves this by including the following preconfigured modes:
--- * `BRIGHTNESS` a mode in which the system brightness can be set
--- * `FILE` a mode in which configured files and directories can be opened and operated on
--- * `SELECT` the mode in which contextual selections of some entity can be selected (i.e. tabs, windows, links, etc.)
--- * `VOLUME` a mode in which the system volume can be set
--- * `WEBSITE` a mode in which configured websites can be opened and operated on
---
--- Parameters:
---  * `options` - A table containing options that configures which default configs to load
---    * `include` - A list of entity filenames to load, in which all unspecified entities will not be loaded
---    * `exclude` - A list of entity filenames to exclude from loading, in which all unspecified filenames will be loaded
function Ki:useDefaultConfig(options)
    options = options or {}

    local defaultShortcuts = {}

    -- Register default state transitions, modes, and shortcuts
    require("default-config")

    -- Validate options and skip if possible
    if options.exclude and options.include then
        local details = "Specify either the `include` or `exclude` option (not both)"
        self.Entity.notifyError("Invalid default config options", details)
        return
    elseif not options.exclude and not options.include then
        return
    end

    -- Memoize include and exclude lists
    local function memoize(t)
        local memo = {}

        for mode, item in pairs(t or {}) do
            if type(item) == "table" then
                for _, key in pairs(item) do
                    memo[mode.."."..key] = true
                end
            else
                memo[item] = true
            end
        end

        return memo
    end
    local includes = memoize(options.include)
    local excludes = memoize(options.exclude)

    for mode, shortcuts in pairs(self.shortcuts) do
        defaultShortcuts[mode] = {}

        for _, shortcut in pairs(shortcuts) do
            local entity = shortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]

            if type(entity) == "table" then
                if options.include and (
                    includes[entity.name] or
                    (entity.name and includes[mode.."."..entity.name])
                ) then
                    table.insert(defaultShortcuts[mode], shortcut)
                end
                if options.exclude and (
                    not excludes[entity.name] and
                    (not excludes[mode.."."..(entity.name or "")])
                ) then
                    table.insert(defaultShortcuts[mode], shortcut)
                end
            end
        end

        -- Register default shortcuts over any existing ones
        self.shortcuts[mode] = {}
        self:registerModeShortcuts(mode, defaultShortcuts[mode])
    end
end

--- Ki:start() -> hs.eventtap
--- Method
--- Initializes the mode indicator, creates all transition and workflow events, and starts the event listener
---
--- Parameters:
---  * None
---
--- Returns:
---   * An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object
function Ki:start()
    -- Set default mode indicator if not provided
    self.modeIndicator = self.modeIndicator or require("mode-indicator")

    -- Create the internal finite state machine
    self.state = FSM.create({
        initial = "desktop",
        events = self.modeTransitionEvents,
        callbacks = self:_createFsmCallbacks()
    })

    -- Make the cheatsheet available in entity mode
    table.insert(self.shortcuts.entity, {
        { "shift" }, "/", function() self.cheatsheet:show() return true end, "Cheatsheet",
    })

    -- Initialize cheat sheet with both default and/or custom transition and workflow events
    local description = "Shortcuts for Ki modes and entities"
    self.cheatsheet = Cheatsheet:new({
        name = self.name,
        description = description,
        shortcuts = self.shortcuts,
        categoryFormatter = function(text)
            return text:gsub("^%l", string.upper).." Mode"
        end,
    })

    -- Set menu item click callback function to show the cheatsheet
    if self.modeIndicator.isDefault then
        self.modeIndicator.menubar:setClickCallback(function()
            self.cheatsheet:show()
        end)
    end

    -- Start the application watcher
    self.ApplicationWatcher:start()

    -- Start keydown event listener
    return self.listener:start()
end

--- Ki:stop() -> hs.eventtap
--- Method
--- Stops the event listener
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
