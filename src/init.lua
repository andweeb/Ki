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

local Ki = {}
Ki.__index = Ki

Ki.name = "Ki"
Ki.version = "1.6.2"
Ki.author = "Andrew Kwon"
Ki.homepage = "https://github.com/andweeb/ki"
Ki.license = "MIT - https://opensource.org/licenses/MIT"

local spoonPath = hs.spoons.scriptPath()
local luaVersion = _VERSION:match("%d+%.%d+")

package.path = package.path..";"..spoonPath.."?.lua"
package.cpath = spoonPath.."/deps/lib/lua/"..luaVersion.."/?.so;"..package.cpath
package.path = spoonPath.."/deps/share/lua/"..luaVersion.."/?.lua;deps/share/lua/"..luaVersion.."/?/init.lua;"..package.path

_G.SHORTCUT_MODKEY_INDEX = 1
_G.SHORTCUT_HOTKEY_INDEX = 2
_G.SHORTCUT_EVENT_HANDLER_INDEX = 3
_G.SHORTCUT_METADATA_INDEX = 4

local FSM = require("fsm")
local Util = require("util")
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

--- Ki.SmartFolder
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some [smart folder](https://support.apple.com/kb/PH25589) at an existing file path. Class methods and properties are documented [here](SmartFolder.html).
Ki.SmartFolder = require("smart-folder")

--- Ki.URL
--- Constant
--- A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some url. Class methods and properties are documented [here](URL.html).
Ki.URL = require("url")

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

-- Merge Ki events with the option of overriding events
-- Events with conflicting hotkeys will result in the lhs event being overwritten by the rhs event
function Ki._mergeEvents(mode, lhs, rhs, overrideLHS)
    -- LHS event modifiers keyed by event keyname
    local lhsHotkeys = {}

    -- Map lhs keynames to modifier keys
    for index, lhsEvent in pairs(lhs) do
        local modifiers = lhsEvent[_G.SHORTCUT_MODKEY_INDEX] or {}
        local keyName = lhsEvent[_G.SHORTCUT_HOTKEY_INDEX]

        lhsHotkeys[keyName] = {
            index = index,
            modifiers = modifiers,
        }
    end

    -- Merge events from rhs to lhs
    for _, rhsEvent in pairs(rhs) do
        -- Determine if event exists in lhs events
        local rhsEventModifiers = rhsEvent[_G.SHORTCUT_MODKEY_INDEX] or {}
        local eventKeyName = rhsEvent[_G.SHORTCUT_HOTKEY_INDEX]
        local eventModifiers = lhsHotkeys[eventKeyName] and lhsHotkeys[eventKeyName].modifiers or nil
        local hasHotkeyConflict = Util.areListsEqual(eventModifiers, rhsEventModifiers)

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

-- A table containing [state transition events](https://github.com/unindented/lua-fsm#usage) that allow transitions between different modes in Ki.
Ki.modeTransitionEvents = {
    -- NORMAL --
    { name = "enterNormalMode", from = "desktop", to = "normal" },
    { name = "exitMode", from = "normal", to = "desktop" },
    -- ENTITY --
    { name = "enterEntityMode", from = "normal", to = "entity" },
    { name = "exitMode", from = "entity", to = "desktop" },
}

-- A table containing lists of shortcuts keyed by mode name.
Ki.shortcuts = {
    desktop = {
        { {"cmd"}, "escape", function() Ki.state:enterNormalMode() end, { "Desktop Mode", "Enter Normal Mode" } },
    },
    normal = {
        { nil, "escape", function() Ki.state:exitMode() end, { "Normal Mode", "Exit to Desktop Mode" } },
        { {"cmd"}, "e", function() Ki.state:enterEntityMode() end, { "Normal Mode", "Enter Entity Mode" } },
    },
    entity = {
        { nil, "escape", function() Ki.state:exitMode() end, { "Entity Mode", "Exit to Desktop Mode" } },
    },
}

--- Ki.statusDisplay
--- Variable
--- A table that defines the behavior for displaying the status of mode transitions. The `show` function should clear out any previous display and show the current transitioned mode. The following methods should be available on the object:
---  * `show` - A function invoked when a mode transition event occurs, with the following arguments:
---    * `status` - A string value containing the current mode
---    * `action` - An action specified in the current active workflow, `nil` otherwise
---
--- Defaults to a simple text display in the center of the menu bar of the focused screen.
Ki.statusDisplay = nil

-- A table that stores the workflow history.
Ki.history = {
    workflow = {},
    action = {},
}

function Ki.history:recordEvent(mode, keyName, flags)
    table.insert(self.workflow, {
        mode = mode,
        flags = flags,
        keyName = keyName,
    })
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
    callbacks.on_enter_state = function(_, _, _, nextState, stateMachine)
        if not self.listener or not self.listener:isEnabled() then
            return
        end

        -- Show the status display with the current mode and record the event to the workflow history
        self.statusDisplay:show(stateMachine.current, next(self.history.action))

        if nextState == "desktop" then
            self.history.workflow = {}
            self.history.action = {}
        end
    end

    return callbacks
end

-- Handle keydown event by triggering the appropriate event handler or entity action dispatcher depending on the mode, modifier keys, and keycode
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
        else
            local hotkeyText = self._renderHotkeyText(flags, keyName)
            local details =
                "The event handler may be misconfigured for the shortcut "..hotkeyText.." in "..mode.." mode."

            self.createEntity().notifyError("Unexpected event handler", details)
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

--- Ki:registerModes(modeTransitionEvents, transitionShortcuts) -> table of state transition events, table of transition shortcuts
--- Method
--- Registers state events that transition between modes and their assigned keyboard shortcuts.
---
--- Parameters:
---  * `modeTransitionEvents` - A table containing the [transition events](https://github.com/unindented/lua-fsm#usage) for the finite state machine set to [`Ki.state`](#state).
---
---     The example state events below create methods on `Ki.state` to enter and exit entity mode from normal mode:
---     ```
---     { { name = "enterEntityMode", from = "normal", to = "entity" }
---       { name = "exitMode", from = "entity", to = "normal" } }
---     ```
---
---     **Note**: these events will only _initialize and expose_ methods on [`Ki.state`](#state). For example, the `Ki.state:enterEntityMode` and `Ki.state:exitMode` methods will only be _initialized_ with the example state events above, in which they can be used in the handler functions for the `transitionShortcuts` in the second argument.
---
---  * `transitionShortcuts` - Lists of shortcut objects keyed by mode name, with each shortcut allowing the transition from and to the modes specified in the `modeTransitionEvents` events.
---
---     Continuing with the example above, we can reference the `Ki.state:enterEntityMode` and `Ki.state:exitMode` methods initialized by the state transitions to define the shortcuts that enter and exit entity mode:
---     ```
---     {
---         -- For when in `normal` mode
---         normal = {
---             -- Register <cmd> + e as the shortcut to enter `entity` mode
---             { {"cmd"}, "e", function() Ki.state:enterEntityMode() end, { "Normal Mode", "Enter Entity Mode" } },
---         },
---         -- For when in `entity` mode
---         entity = {
---             -- Register <escape> as the shortcut to exit back to `desktop` mode
---             { nil, "escape", function() Ki.state:exitMode() end, { "Entity Mode", "Exit to Desktop Mode" } },
---         },
---     }
---     ```
function Ki:registerModes(modeTransitionEvents, transitionShortcuts)
    -- Register FSM state transition events
    for _, modeTransition in pairs(modeTransitionEvents) do
        table.insert(self.modeTransitionEvents, modeTransition)
    end

    -- Register transition shortcuts
    return self.modeTransitionEvents, self:registerShortcuts(transitionShortcuts, true)
end

--- Ki:registerShortcuts(shortcuts[, override]) -> table of registered shortcuts
--- Method
--- Registers a list of shortcuts for one or more modes.
---
--- For each shortcut, the table structure matches the argument list for hotkey bindings in Hammerspoon: modifier keys list, key name, and event handler. An optional but recommended fourth item is a list with category and name of the shortcut to be displayed in the cheatsheet. For example, the following events open applications on keydown events on <kbd>s</kbd> and <kbd>⇧⌘s</kbd>:
---
--- An [`Entity`](#Entity) (or any subclassed Entity) instance can be also used as an event handler:
--- ```lua
--- local shortcuts = {
---     entity = {
---         { nil, "w", Ki.Application:new("Microsoft Word"), { "Entities", "Microsoft Word" } },
---         { { "cmd", "shift" }, "s", Ki.Application:new("Slack"), { "Entities", "Slack" } },
---     },
---     select = {
---         { nil, "w", Ki.Application:new("Microsoft Word"), { "Entities", "Microsoft Word" } },
---     },
--- }
--- ```
--- The boolean return value of the event handler or an entity's `dispatchAction` function indicates whether to automatically exit back to `desktop` mode after the action has completed.
---
--- Parameters:
---  * `shortcuts` - The list of shortcut objects
---  * `override` - A boolean denoting whether to override existing shortcuts
function Ki:registerShortcuts(shortcuts, override)
    override = override == nil and true or override

    for mode, modeShortcuts in pairs(shortcuts) do
        if not self.shortcuts[mode] then
            self.shortcuts[mode] = {}
        end

        self._mergeEvents(mode, self.shortcuts[mode], modeShortcuts, override)
    end

    return self.shortcuts
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
---     -- Remap the following URL shortcuts using their metadata
---     -- { nil, "f", urls.Facebook, { "URL Events", "Facebook" } },
---     -- { nil, "m", urls.Messenger, { "URL Events", "Facebook Messenger" } },
---     ["URL Events"] = {
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
---     -- Remap the following URL entities available in url mode:
---     -- Ki.defaultEntities.url.Facebook.name == "https://facebook.com"
---     -- Ki.defaultEntities.url.Messenger.name == "https://messenger.com"
---     url = {
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
function Ki:remapShortcuts(categories)
    -- Memoize shortcuts using contatenated category and shortcut name keys delimited by "."
    local memo = {}
    for categoryName, shortcuts in pairs(categories) do
        for shortcutName, shortcut in pairs(shortcuts) do
            local key = categoryName.."."..shortcutName
            memo[key] = shortcut
        end
    end

    -- Iterate through modal shortcuts to either remap or unmap
    local unmappedModes = {}
    for mode, modeShortcuts in pairs(self.shortcuts) do
        for i, shortcut in pairs(modeShortcuts) do
            local remappedKeys = {}
            local modkeyIndex = _G.SHORTCUT_MODKEY_INDEX
            local hotkeyIndex = _G.SHORTCUT_HOTKEY_INDEX
            local metaIndex = _G.SHORTCUT_METADATA_INDEX

            -- Find shortcut using shortcut metadata
            local categoryName, shortcutName = table.unpack(shortcut[metaIndex] or {})
            if categoryName and shortcutName and memo[categoryName.."."..shortcutName] then
                remappedKeys = memo[categoryName.."."..shortcutName]
            end

            -- Find shortcut using the mode and entity name
            local entity = shortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]
            if type(entity) == "table" and entity.name and memo[mode.."."..entity.name] then
                remappedKeys = memo[mode.."."..entity.name]
            end

            -- Remap the shortcut if found
            if remappedKeys.unmap then
                modeShortcuts[i] = nil
                unmappedModes[mode] = true
            elseif #remappedKeys ~= 0 then
                shortcut[modkeyIndex], shortcut[hotkeyIndex] = table.unpack(remappedKeys)
            end
        end
    end

    -- Compact the nil values in modes that had shortcuts unmapped
    for mode in pairs(unmappedModes) do
        local compactedList = {}
        local shortcuts = self.shortcuts[mode]

        for i = 1, #shortcuts do
            local shortcut = shortcuts[i]

            if shortcut ~= nil then
                table.insert(compactedList, shortcut)
            end
        end

        self.shortcuts[mode] = compactedList
    end
end

--- Ki:useDefaultConfig([options])
--- Method
--- Loads the default config
---
--- The default config initializes and assigns preset keybindings for almost all native macOS applications, common directory files, and popular websites, and achieves this by including the following preconfigured modes:
--- * `URL` a mode in which URLs can be selected and opened
--- * `FILE` a mode in which files and directories can be automated
--- * `SELECT` the mode in which tabs or windows of entities can be selected
--- * `VOLUME` a mode in which the system volume can be set
--- * `BRIGHTNESS` a mode in which the system brightness can be set
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
                    includes[entity.url] or
                    includes[entity.path] or
                    includes[entity.name] or
                    (entity.url and includes[mode.."."..entity.url]) or
                    (entity.path and includes[mode.."."..entity.path]) or
                    (entity.name and includes[mode.."."..entity.name])
                ) then
                    table.insert(defaultShortcuts[mode], shortcut)
                end
                if options.exclude and (
                    not excludes[entity.url] and
                    not excludes[entity.path] and
                    not excludes[entity.name] and
                    (not excludes[mode.."."..(entity.url or "")]) and
                    (not excludes[mode.."."..(entity.path or "")]) and
                    (not excludes[mode.."."..(entity.name or "")])
                ) then
                    table.insert(defaultShortcuts[mode], shortcut)
                end
            end
        end
    end

    -- Register default shortcuts over any existing ones
    self:registerShortcuts(defaultShortcuts, true)
end

--- Ki:start() -> hs.eventtap
--- Method
--- Sets the status display, creates all transition and workflow events, and starts the event listener
---
--- Parameters:
---  * None
---
--- Returns:
---   * An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object
function Ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or require("status-display")

    -- Create the internal finite state machine
    self.state = FSM.create({
        initial = "desktop",
        events = self.modeTransitionEvents,
        callbacks = self:_createFsmCallbacks()
    })

    -- Make the cheatsheet available in entity mode
    table.insert(self.shortcuts.entity, {
        { "shift" }, "/", function() self.cheatsheet:show() return true end, { "Entities", "Cheatsheet" },
    })

    -- Collect all shortcuts in a flattened list
    local shortcuts = {}
    for _, modeShortcuts in pairs(self.shortcuts) do
        for _, shortcut in pairs(modeShortcuts) do
            table.insert(shortcuts, shortcut)
        end
    end

    -- Initialize cheat sheet with both default and/or custom transition and workflow events
    local description = "Shortcuts for Ki modes and entities"
    self.cheatsheet = Cheatsheet:new(self.name, description, shortcuts)

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
