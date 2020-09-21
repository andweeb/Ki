--- === Application ===
---
--- Application class that subclasses [Entity](Entity.html) to represent some automatable desktop application
---

local Entity = require("entity")
local ApplicationWatcher = require("application-watcher")

local Application = Entity:subclass("Application")
local Behaviors = {}

-- Application behavior function for entity mode
function Behaviors.entity(self, eventHandler, _, _, workflow)
    -- Determine whether the workflow includes select mode
    local shouldSelect = false
    for _, event in pairs(workflow) do
        if event.mode == "select" then
            shouldSelect = true
            break
        end
    end

    -- Execute the select behavior if the workflow includes select mode
    if shouldSelect then
        return Behaviors.select(self, eventHandler)
    end

    -- Handle action-specific options
    local options = nil
    local action = eventHandler
    if type(eventHandler) == "table" then
        action = eventHandler[1]
        options = eventHandler[2]
    end

    -- Create local action execution function to either defer or immediately invoke
    local function executeAction(appInstance)
        local _, autoExit = action(appInstance)
        return autoExit == nil and self.autoExitMode or autoExit
    end

    return Behaviors.dispatchAction(self, executeAction, options)
end

-- Application behavior function for select mode
function Behaviors.select(self, eventHandler)
    local options = nil
    local action = eventHandler
    if type(eventHandler) == "table" then
        action = eventHandler[1]
        options = eventHandler[2]
    end

    -- Create local action execution function to either defer or immediately invoke
    local function executeAction(appInstance)
        local choices = self:getChooserItems()
        local function getChoices()
            return choices
        end

        if choices and #choices > 0 then
            self:showChooser(getChoices, function (choice)
                if choice then
                    action(appInstance, choice)
                end
            end)

            self:loadChooserRowImages(choices)
        end
    end

    Behaviors.dispatchAction(self, executeAction, options)

    return self.autoExitMode
end

-- Use the entity mode behavior as the default behavior
Behaviors.default = Behaviors.entity

-- Dispatch action behavior for application entities to defer action execution after launch
function Behaviors.dispatchAction(self, action, options)
    options = options or {
        openBefore = true,
    }

    local appState = ApplicationWatcher.states[self.name]
    local app = self:getApplication()
    local status = nil

    if appState then
        app = appState.app
        status = appState.status
    end

    -- Determine whether the application is currently open
    local isActivated = status == ApplicationWatcher.statusTypes.activated
    local isLaunched = status == ApplicationWatcher.statusTypes.launched
    local isUnhidden = status == ApplicationWatcher.statusTypes.unhidden
    local isApplicationOpen = isActivated or isLaunched or isUnhidden
    local isApplicationRunning = app and app:isRunning() or isApplicationOpen

    -- Execute the action if the application is already running and return indicator to auto-exit mode
    if not options.openBefore or isApplicationRunning then
        local autoExit = action(app)
        return autoExit == nil and self.autoExitMode or autoExit
    end

    -- Determine the target event based on the current application status
    local targetEvent = ApplicationWatcher.statusTypes.launched
    if status == ApplicationWatcher.statusTypes.deactivated then
        targetEvent = ApplicationWatcher.statusTypes.activated
    elseif status == ApplicationWatcher.statusTypes.hidden then
        targetEvent = ApplicationWatcher.statusTypes.unhidden
    end

    -- Defer the action execution to until the application has opened
    ApplicationWatcher:registerEventCallback(self.name, targetEvent, action)

    -- Launch the application
    hs.application.open(self.name)

    return self.autoExitMode
end

--- Application.behaviors
--- Variable
--- Application [behaviors](Entity.html#behaviors) defined to invoke event handlers with `hs.application`.
Application.behaviors = Entity.behaviors + Behaviors

--- Application:getChooserItems()
--- Method
--- Default implementation of [`Entity:getChooserItems()`](Entity.html#getChooserItems) to returns choice objects containing application window information.
---
--- This can be overridden for instances to return chooser items particular for specific Application entities, i.e. override this function to return conversation choices for the Messages instance.
---
--- Parameters:
---  * None
---
--- Returns:
---   * A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects
function Application:getChooserItems()
    local app = self:getApplication()
    local windows = app:allWindows()
    local choices = {}

    for index, window in pairs(windows) do
        local state = window:isFullScreen() and "(full screen)"
            or window:isMinimized() and "(minimized)"
            or ""

        table.insert(choices, {
            text = window:title(),
            subText = "Window "..index.." "..state,
            windowId = window:id(),
            windowIndex = index,
        })
    end

    return choices
end

--- Application.createMenuItemEvent(menuItem[, shouldFocusAfter, shouldFocusBefore])
--- Method
--- Convenience method to create an event handler that selects a menu item, with optionally specified behavior on how the menu item selection occurs
---
--- Parameters:
---  * `menuItem` - the menu item to select, specified as either a string or a table
---  * `options` - a optional table containing some or all of the following fields to define the behavior for the menu item selection event:
---     * `isRegex` - a boolean denoting whether there is a regular expression within the menu item name(s)
---     * `isToggleable` - a boolean denoting whether the menu item parameter is passed in as a list of two items to toggle between, i.e., `{ "Play", "Pause" }`
---     * `focusBefore` - an optional boolean denoting whether to focus the application before the menu item is selected
---     * `focusAfter` - an optional boolean denoting whether to focus the application after the menu item is selected
---
--- Returns:
---  * None
function Application.createMenuItemEvent(menuItem, options)
    options = options or {}

    return function(app, choice)
        if (options.focusBefore) then
            Application.focus(app, choice)
        end

        if options.isToggleable then
            _ = app:selectMenuItem(menuItem[1], options.isRegex)
                or app:selectMenuItem(menuItem[2], options.isRegex)
        else
            app:selectMenuItem(menuItem, options.isRegex)
        end

        if (options.focusAfter) then
            Application.focus(app, choice)
        end
    end
end

--- Application.createMenuItemChooserEvent(menuItem[, shouldFocusAfter, shouldFocusBefore])
--- Method
--- Convenience method to create an event handler that presents a chooser containing menu items that are nested/expandable underneath at the provided `menuItem` path, with optionally specified behavior on how the menu item selection occurs
---
--- Parameters:
---  * `menuItem` - a table list of strings that represent a path to a menu item that expands to menu item list, i.e., `{ "File", "Open Recent" }`
---  * `options` - a optional table containing some or all of the following fields to define the behavior for the menu item selection event:
---     * `focusBefore` - an optional boolean denoting whether to focus the application before the menu item is selected
---     * `focusAfter` - an optional boolean denoting whether to focus the application after the menu item is selected
---
--- Returns:
---  * None
function Application.createMenuItemChooserEvent(menuItem, options)
    options = options or {}

    return function(app, windowChoice)
        local menuItemList = Application.getMenuItemList(app, menuItem)
        local choices = {}

        for _, item in pairs(menuItemList) do
            if item.AXTitle and #item.AXTitle > 0 then
                table.insert(choices, {
                    text = item.AXTitle,
                })
            end
        end

        Application:showChooser(choices, function(menuItemChoice)
            if menuItemChoice then
                if (options.focusBefore) then
                    Application.focus(app, windowChoice)
                end

                local targetMenuItem = {table.unpack(menuItem)}

                table.insert(targetMenuItem, menuItemChoice.text)

                app:selectMenuItem(targetMenuItem)

                if (options.focusAfter) then
                    Application.focus(app, windowChoice)
                end
            end
        end)
    end
end

--- Application.getMenuItemList(app, menuItemPath) -> table or nil
--- Method
--- Gets a list of menu items from a hierarchical menu item path
---
--- Parameters:
---  * `app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object
---  * `menuItemPath` - A table representing the hierarchical path of the target menu item (e.g. `{ "File", "Share" }`)
---
--- Returns:
---   * A list of [menu items](https://www.hammerspoon.org/docs/hs.application.html#getMenuItems) or `nil`
function Application.getMenuItemList(app, menuItemPath)
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

-- Show cheatsheet action
function Application:showCheatsheet(app)
    local bundleId = app and app:bundleID() or nil
    local iconURI = nil

    if not bundleId then
        local _, id = hs.osascript.applescript([[id of app "]]..self.name..[["]])
        bundleId = id
    end

    if bundleId then
        local iconImage = hs.image.imageFromAppBundle(bundleId)
        iconURI = iconImage:encodeAsURLString()
    end

    self.cheatsheet:show(iconURI)
end

--- Application:getApplication() -> hs.application object or nil
--- Method
--- Gets the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object from the instance name
---
--- Parameters:
---  * None
---
--- Returns:
---   * An `hs.application` object or `nil` if the application could not be found
function Application:getApplication()
    return hs.application.get(self.name)
end

--- Application:focus(app[, choice])
--- Method
--- Activates an application or focuses a specific application window or tab
---
--- Parameters:
---  * `app` - the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object
---  * `choice` - an optional [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) object, each with a `windowId` field and (optional) `tabIndex` field
---
--- Returns:
---   * None
function Application.focus(app, choice)
    if choice then
        local window = hs.window(tonumber(choice.windowId))

        if window then window:focus() end
        if window and choice.tabIndex then
            window:focusTab(choice.tabIndex)
        end
    elseif app then
        app:activate()
    end
end

--- Application:toggleFullScreen(app)
--- Method
--- Toggles the full screen state of the focused application window
---
--- Parameters:
---  * `app` - the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object
---
--- Returns:
---   * `true`
function Application.toggleFullScreen(app)
    app:focusedWindow():toggleFullScreen()
    return true
end

--- Application:initialize(name, shortcuts, autoExitMode)
--- Method
--- Initializes a new application instance with its name and shortcuts. By default, common shortcuts are automatically registered, and the initialized [entity](Entity.html) defaults, such as the cheatsheet.
---
--- Parameters:
---  * `name` - The entity name
---  * `shortcuts` - The list of shortcuts containing keybindings and actions for the entity
---  * `autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
---
--- The structure of each shortcut in `shortcuts` is a list containing the following values:
---   1. a list of [modifier keys](http://www.hammerspoon.org/docs/hs.hotkey.html#bind) or `nil`
---   2. a string containing the name of a keyboard key (as found in [hs.keycodes.map](http://www.hammerspoon.org/docs/hs.keycodes.html#map))
---   3. the event handler which can be one of the following values:
---      * a function that takes the following arguments:
---        * `app` - The [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) instance if the application is running, `nil` otherwise
---        * `choice` - A choice object if the entity was selected using select mode, `nil` otherwise
---      * a tuple containing the function with arguments outlined above and the following options:
---        * `openBefore` - A boolean value indicating that the application should be opened if not curently running before applying the action (defaults to `true`)
---      A boolean return value will tell Ki to automatically exit back to `desktop` mode after the action has completed.
---   4. a tuple containing metadata about the shortcut: name of the shortcut category and description of the shortcut to be displayed in the cheatsheet
---
--- Returns:
---  * None
function Application:initialize(options)
    local name, shortcuts

    if type(options) == "string" then
        name = options
    elseif #options > 0 then
        name, shortcuts = table.unpack(options)
    else
        name = options.name
        shortcuts = options.shortcuts
    end

    local mergedShortcuts = self:mergeShortcuts(shortcuts or {}, {
        { nil, nil, self.focus, { name, "Activate" } },
        { nil, "a", self.createMenuItemEvent("About "..name), { name, "About "..name } },
        { nil, "f", self.toggleFullScreen, { "View", "Toggle Full Screen" } },
        { nil, "h", self.createMenuItemEvent("Hide "..name), { name, "Hide Application" } },
        { nil, "q", self.createMenuItemEvent("Quit "..name), { name, "Quit Application" } },
        { nil, ",", self.createMenuItemEvent("Preferences..."), { name, "Open Preferences" } },
        { { "cmd" }, "space", { function(...) self:showActions(...) end, { openBefore = false } }, { name, "Show Actions" } },
        { { "shift" }, "/", { function(...) self:showCheatsheet(...) end, { openBefore = false } }, { name, "Show Cheatsheet" } },
    })

    Entity.initialize(self, {
        name = name,
        actions = options.actions,
        shortcuts = mergedShortcuts,
        getChooserItems = options.getChooserItems,
    })
end

return Application
