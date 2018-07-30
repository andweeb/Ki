--- === Entity ===
---
--- Entity class that represents automatable desktop entities, i.e., applications, desktop spaces, Siri, etc.
---

local luaVersion = _VERSION:match("%d+%.%d+")

if not _G.getSpoonPath then
    function _G.getSpoonPath()
        return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
    end
end

-- luacov: disable
if not _G.requirePackage then
    function _G.requirePackage(name, isInternal)
        local location = not isInternal and "/deps/share/lua/"..luaVersion.."/" or "/"
        local packagePath = _G.getSpoonPath()..location..name..".lua"

        return dofile(packagePath)
    end
end
-- luacov: enable

local class = _G.requirePackage("middleclass")
local lustache = _G.requirePackage("lustache")
local util = _G.requirePackage("util", true)
local cheatsheet = _G.requirePackage("cheatsheet", true)

local Entity = class("Entity")

local SHORTCUT_MODKEY_INDEX = 1
local SHORTCUT_HOTKEY_INDEX = 2
local SHORTCUT_EVENT_HANDLER_INDEX = 3

--- Entity.notifyError(message, details)
--- Method
--- Displays error details in a notification and logs to the Hammerspoon console
---
--- Parameters:
---  * `message` - The main notification message
---  * `details` - The textual body of the notification containing details of the error
---
--- Returns:
---  * None
function Entity.notifyError(message, details)
    hs.notify.show("Ki", message, details)
    print("[Ki] "..message..":", details)
end

--- Entity.getMenuItemList(app, menuItemPath) -> table or nil
--- Method
--- Gets a list of menu items from a hierarchical menu item path
---
--- Parameters:
---  * `app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object
---  * `menuItemPath` - A table representing the hierarchical path of the target menu item (e.g. `{ "File", "Share" }`)
---
--- Returns:
---   * A list of [menu items](https://www.hammerspoon.org/docs/hs.application.html#getMenuItems) or `nil`
function Entity.getMenuItemList(app, menuItemPath)
    local menuItems = app:getMenuItems()
    local isFound = false

    for _, menuItemName in pairs(menuItemPath) do
        for _, menuItem in pairs(menuItems) do
            if menuItem.AXTitle == menuItemName then
                menuItems = menuItem.AXChildren[1]

                if menuItemName ~= menuItemPath[#menuItemPath] then
                    isFound = true
                end
            end
        end
    end

    return isFound and menuItems or nil
end

--- Entity.renderScriptTemplate(scriptName[, viewModel]) -> string
--- Method
--- Generates an applescript template string with a given view model object
---
--- Parameters:
---  * `scriptName` - The applescript file name
---  * `viewModel` - An optional [lustache](http://olivinelabs.com/lustache/) view model
---
--- Returns:
---  * The rendered script string
function Entity.renderScriptTemplate(scriptName, viewModel)
    viewModel = viewModel or {}

    local localScriptPath = _G.getSpoonPath().."/osascripts/"..scriptName..".applescript"
    local scriptPath = string.match(scriptName, "/") and scriptName or localScriptPath
    local file = assert(io.open(scriptPath, "rb"))
    local scriptTemplate = file:read("*all")

    file:close()

    return lustache:render(scriptTemplate, viewModel)
end

--- Entity:initialize(name, shortcuts, autoExitMode)
--- Method
--- Initializes a new entity instance with its name and available shortcuts. By default, a `cheatsheet` object will be initialized on the entity object with the provided shortcut keybindings, and dispatched actions will automatically exit the current mode by default unless `autoExitMode` is explicitly set to `false`.
---
--- Parameters:
---  * `name` - The entity name
---  * `shortcuts` - The list of shortcuts containing keybindings and actions for the entity
---  * `autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
---
--- Each `shortcut` item should be a list with items at the following indices:
---  * `1` - An optional table containing zero or more of the following keyboard modifiers: `"cmd"`, `"alt"`, `"shift"`, `"ctrl"`, `"fn"`
---  * `2` - The name of a keyboard key. String representations of keys can be found in [`hs.keycodes.map`](https://www.hammerspoon.org/docs/hs.keycodes.html#map).
---  * `3` - The event handler that defines the action for when the shortcut is triggered
---  * `4` - A table containing the metadata for the shortcut, also a list with items at the following indices:
---    * `1` - The category name of the shortcut
---    * `2` - A description of what the shortcut does
---
--- Returns:
---  * None
function Entity:initialize(name, shortcuts, autoExitMode)
    self.name = name
    self.autoExitMode = autoExitMode ~= nil and autoExitMode or true
    self:registerShortcuts(shortcuts or {})
    self.cheatsheet = cheatsheet

    local cheatsheetDescription = "Ki shortcut keybindings registered for "..self.name
    self.cheatsheet:init(self.name, cheatsheetDescription, self.shortcuts)
end

--- Entity:getApplication() -> hs.application object or nil
--- Method
--- Gets the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object from the entity name
---
--- Parameters:
---  * None
---
--- Returns:
---   * An `hs.application` object or `nil` if the application could not be found
function Entity:getApplication()
    local applicationName = self.name
    local app = hs.application.get(applicationName)

    if not app then
        hs.application.launchOrFocus(applicationName)
        app = hs.appfinder.appFromName(applicationName)
    end

    return app
end

--- Entity.mergeShortcuts(fromList, toList) -> table
--- Method
--- Merges lists of shortcuts based on their keybindings
---
--- Parameters:
---  * `fromList` - The list of shortcuts to apply onto the second list argument
---  * `toList` - The target list of shortcuts to override those in the first list argument
---
--- Returns:
---   * `list` - The list of merged shortcut objects
function Entity.mergeShortcuts(fromList, toList)
    if not fromList or #fromList == 0 then
        return toList
    end

    for _, shortcut in pairs(fromList) do
        local modifierKeys = shortcut[SHORTCUT_MODKEY_INDEX] or {}
        local hotkey = shortcut[SHORTCUT_HOTKEY_INDEX]
        local overrideIndex = nil

        for index, registeredAction in pairs(toList) do
            local registeredModifierKeys = registeredAction[SHORTCUT_MODKEY_INDEX] or {}
            local registeredHotkey = registeredAction[SHORTCUT_HOTKEY_INDEX]

            if hotkey == registeredHotkey and util.areListsEqual(modifierKeys, registeredModifierKeys) then
                overrideIndex = index
            end
        end

        if overrideIndex then
            table.remove(toList, overrideIndex)
        end

        table.insert(toList, shortcut)
    end

    return toList
end

--- Entity:getSelectionItems(appName) -> table of choices or nil
--- Method
--- A placeholder method to return a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects for the selection modal. Subclassed entities intended to be used with select mode must implement this method to correctly display items in the selection modal.
---
--- Parameters:
---  * `appName` - The entity application name
---
--- Returns:
---   * `selectionItems` - A list of choices or `nil`
function Entity:getSelectionItems(appName) -- luacheck: ignore
    return nil
end

--- Entity.showSelectionModal(app, choices, selectEventHandler)
--- Method
--- Shows a selection modal with a list of choices. Highlight items up and down with <kbd>⌃j</kbd> and <kbd>⌃k</kbd>, and close the modal with <kbd>Escape</kbd>.
---
--- Parameters:
---  * `app` - The [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object for the entity or nil
---  * `choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser modal
---  * `selectEventHandler` - The callback function invoked when a choice is selected from the modal
---
--- Returns:
---  * None
function Entity.showSelectionModal(app, choices, selectEventHandler)
    local selectionListener = nil
    local modal = hs.chooser.new(function(choice)
        -- Stop selection listener and invoke the event handler
        selectionListener:stop()
        if choice then
            selectEventHandler(app, choice)
        end
    end)

    modal:choices(choices)
    modal:searchSubText(true)
    modal:bgDark(true)

    -- Create an event listener while the chooser is visible to select rows with ctrl+j/k
    selectionListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyName = hs.keycodes.map[event:getKeyCode()]
        local selectedRow = modal:selectedRow()

        if (keyName == "j" or keyName == "k") and flags:containExactly({"ctrl"}) then
            if keyName == "j" then
                modal:selectedRow(selectedRow + 1)
            elseif keyName == "k" then
                modal:selectedRow(selectedRow - 1)
            end

            return true
        end
    end)

    -- Start row selection listener and show the modal
    selectionListener:start()
    modal:show()
end

function Entity.focus(app, choice)
    if choice then
        local window = hs.window(tonumber(choice.windowId))
        _ = window:focus() and window:focusTab(choice.tabIndex)
    elseif app then
        app:activate()
    end
end

function Entity.toggleFullScreen(app)
    app:focusedWindow():toggleFullScreen()
    return true
end

function Entity:hide(app)
    app:selectMenuItem("Hide "..self.name)
end

function Entity:quit(app)
    app:selectMenuItem("Quit "..self.name)
end

function Entity.openPreferences(app)
    app:selectMenuItem("Preferences...")
    return true
end

--- Entity:registerShortcuts(shortcuts)
--- Method
--- Registers the list of shortcuts applicable to the entity object
---
--- Parameters:
---  * `shortcuts` - The list of shortcuts for the entity
---
--- Returns:
---  * None
function Entity:registerShortcuts(shortcuts)
    local defaultShortcuts = {
        { nil, nil, self.focus, { self.name, "Activate/Focus" } },
        { nil, "f", self.toggleFullScreen, { "View", "Toggle Full Screen" } },
        { nil, "h", function(app) self:hide(app) end, { self.name, "Hide Application" } },
        { nil, "q", function(app) self:quit(app) end, { self.name, "Quit Application" } },
        { nil, ",", self.openPreferences, { self.name, "Open Preferences" } },
        {
            { "shift" }, "/",
            function() self.cheatsheet:show() end,
            { self.name, "Show Cheatsheet" },
        },
    }

    local registeredShortcuts = self.mergeShortcuts(shortcuts, defaultShortcuts)

    self.shortcuts = registeredShortcuts
end

--- Entity:invokeEventHandler(app, mode, eventHandler)
--- Method
--- Invokes an action with different parameters depending on the current Ki mode
---
--- Parameters:
---  * `app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object
---  * `mode` - The current mode name
---  * `eventHandler` - The action event handler
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity:invokeEventHandler(app, mode, eventHandler)
    if mode == "select" then
        local choices = self:getSelectionItems()

        if choices and #choices then
            self.showSelectionModal(app, choices, eventHandler)
        end

        return true
    else
        local autoFocus, autoExit = eventHandler(app)

        if app and autoFocus == true then
            self.focus(app)
        end

        return autoExit == nil and self.autoExitMode or autoExit
    end
end

function Entity.getShortcutHandler(shortcuts, flags, keyName)
    for _, registeredShortcut in pairs(shortcuts) do
        local registeredFlags = registeredShortcut[SHORTCUT_MODKEY_INDEX]
        local registeredKeyName = registeredShortcut[SHORTCUT_HOTKEY_INDEX]
        local registeredHandler = registeredShortcut[SHORTCUT_EVENT_HANDLER_INDEX]
        local areFlagsEqual = flags == registeredFlags or
            (flags and flags.containExactly and flags:containExactly(registeredFlags or {}))

        if areFlagsEqual and keyName == registeredKeyName then
            return registeredHandler
        end
    end
end

--- Entity:dispatchAction(mode, shortcut) -> boolean
--- Method
--- Dispatch an action from a triggered shortcut for an entity
---
--- Parameters:
---  * `mode` - The name of the current mode
---  * `shortcut` - A shortcut object with an action to invoke on the entity
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity:dispatchAction(mode, shortcut)
    local flags = shortcut.flags
    local keyName = shortcut.keyName
    local app = self.name
        and self:getApplication()
        or nil

    if not app then
        return self.autoExitMode
    end

    local registeredHandler = self.getShortcutHandler(self.shortcuts, flags, keyName)

    if registeredHandler then
        return self:invokeEventHandler(app, mode, registeredHandler)
    else
        return self.autoExitMode
    end
end

return Entity
