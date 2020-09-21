--- === Entity ===
---
--- Entity class that represents some abstract automatable desktop entity
---
local class = require("middleclass")
local lustache = require("lustache")
local Cheatsheet = require("cheatsheet")
local glyphs = require("glyphs")

local Entity = class("Entity")

-- Helper method to clone table
local function cloneTable(input)
    if type(input) ~= "table" then
        return input
    end

    local copy = {}
    for key, value in next, input, nil do
        copy[cloneTable(key)] = cloneTable(value)
    end

    setmetatable(copy, cloneTable(getmetatable(input)))

    return copy
end

--- Entity.behaviors
--- Variable
--- A table keyed by mode name to define (optional) entity behavior contextual to the mode at the time of an event. The table values are functions that take in the following arguments to invoke the event handler in some mode-specific way:
---  * `self` - the entity (or subclassed entity) instance
---  * `eventHandler` - the event handler to be invoked within the function
---  * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
---  * `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---
--- The table is defined with an `__add` metamethod to overwrite the default entity behaviors.
---
--- Currently supported behaviors:
--- * `default` - triggers the event handler and returns a boolean flag whether to auto-exit back to desktop mode or not, depending on the return value of the handler or the `autoExitMode` variable on the entity class
Entity.behaviors = {
    default = function(self, eventHandler)
        local _, autoExit = eventHandler()

        return autoExit == nil and self.autoExitMode or autoExit
    end,
}

-- Allow behaviors to be overwritten
setmetatable(Entity.behaviors, {
    __add = function(lhs, rhs)
        lhs = cloneTable(lhs)

        for mode, behavior in pairs(rhs) do
            lhs[mode] = behavior
        end

        return lhs
    end,
})

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

--- Entity.renderScriptTemplate(script[, viewModel]) -> string
--- Method
--- Generates an applescript from templates located in `src/osascripts` with some view model object
---
--- Parameters:
---  * `scriptPath` - The absolute file path to the applescript file or the name of an existing Ki applescript file (in src/osascripts)
---  * `viewModel` - An optional [lustache](http://olivinelabs.com/lustache/) view model
---
--- Returns:
---  * The rendered script string or `nil`
function Entity.renderScriptTemplate(script, viewModel)
    viewModel = viewModel or {}

    local scriptPath = script

    if not scriptPath:match("/") then
        local spoonPath = hs.spoons.scriptPath()
        local localScriptPath = spoonPath.."osascripts/"..script..".applescript"
        scriptPath = string.match(script, "/") and script or localScriptPath
    end

    local success, file = pcall(function() return assert(io.open(scriptPath, "rb")) end)

    if not success or not file then
        Entity.notifyError("Unable to render script template for the script", script)
        return nil
    end

    local scriptTemplate = file:read("*all")

    file:close()

    return lustache:render(scriptTemplate, viewModel)
end

--- Entity:initialize(TODO)
--- Method
--- Initializes a new entity instance with its name and shortcuts. By default, a `cheatsheet` object will be initialized on the entity object with metadata in the provided shortcut keybindings, and dispatched actions will automatically exit the current mode by default unless the `autoExitMode` parameter is explicitly set to `false`.
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
function Entity:initialize(options)
    local name, actions, shortcuts, autoExitMode, getChooserItems

    if type(options) == "string" then
        name = options
    elseif #options > 0 then
        name, shortcuts, autoExitMode = table.unpack(options)
    else
        name = options.name
        actions = options.actions
        shortcuts = options.shortcuts
        autoExitMode = options.autoExitMode
        getChooserItems = options.getChooserItems
    end

    self.name = name
    self.actions = actions
    self.getChooserItems = getChooserItems
    self.autoExitMode = autoExitMode ~= nil and autoExitMode or true
    self:registerShortcuts(self:mergeShortcuts(shortcuts or {}, {
        { { "cmd" }, "space", function(...) self:showActions(...) end, { name, "Show Actions" } },
        { { "shift" }, "/", function() self.cheatsheet:show() end, { name, "Show Cheatsheet" } },
    }))
end

-- Create a string shortcut key from its modifiers and hotkey
function Entity.getShortcutKey(modifiers, hotkey)
    if not hotkey or not modifiers then
        return tostring(hotkey)
    end

    local clonedModifiers = {table.unpack(modifiers)}
    table.sort(clonedModifiers)

    return table.concat(clonedModifiers)..hotkey
end

-- Merge Ki shortcuts with the option of overriding shortcuts
-- Shortcuts with conflicting hotkeys will result in the `toList` shortcut being overwritten by the `fromList` shortcut
function Entity:mergeShortcuts(fromList, toList)
    fromList = fromList or {}
    toList = toList or {}

    local mergedShortcuts = {table.unpack(fromList)}
    local memo = {}

    for i = 1, #mergedShortcuts do
        local shortcut = mergedShortcuts[i]
        local key = self.getShortcutKey(table.unpack(shortcut))
        memo[key] = { i, shortcut }
    end

    for i = 1, #toList do
        local shortcut = toList[i]
        local key = self.getShortcutKey(table.unpack(shortcut))
        local foundIndex, foundShortcut = table.unpack(memo[key] or {})

        if foundIndex then
            mergedShortcuts[foundIndex] = foundShortcut
        else
            table.insert(mergedShortcuts, shortcut)
        end
    end

    return mergedShortcuts
end

--- Entity:registerShortcuts(shortcuts[, override]) -> table of shortcuts
--- Method
--- Registers and updates the entity cheatsheet with a list of shortcuts with the option of merging with the existing default or previously initialized shortcuts.
---
--- Parameters:
---  * `shortcuts` - The list of shortcut objects
---  * `override` - A boolean denoting to whether to override the existing set of shortcuts
---
--- Returns:
---   * `shortcuts` - Returns the list of registered shortcuts
function Entity:registerShortcuts(shortcuts, override)
    local cheatsheetDescription = self.name and "Ki shortcut keybindings registered for "..self.name or "Ki shortcut keybindings"

    self.shortcuts = override and shortcuts or self:mergeShortcuts(shortcuts, self.shortcuts or {})
    self.cheatsheet = Cheatsheet:new(self.name, cheatsheetDescription, self.shortcuts)

    return self.shortcuts
end

--- Entity:getChooserItems() -> table of choices or nil
--- Method
--- Returns a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display in the chooser. Entities intended to be used with select mode must implement this method to correctly display items in the chooser.
---
--- Returns:
---   * `choices` - A list of choices or `nil`
-- luacov: disable
function Entity:getChooserItems() -- luacheck: ignore
    return nil
end
-- luacov: enable

--- Entity.triggerAfterConfirmation(question, details, action)
--- Method
--- Opens a dialog block alert for user confirmation before triggering an action
---
--- Parameters:
---  * `question` - Text to display in the block alert as the title
---  * `details` - Text to display in the block alert as the description
---  * `action` - The callback function to be invoked after user confirmation
---
--- Returns:
---   * None
function Entity.triggerAfterConfirmation(question, details, action)
    hs.timer.doAfter(0, function()
        hs.focus()

        local answer = hs.dialog.blockAlert(question, details, "Confirm", "Cancel")

        if answer == "Confirm" then action() end
    end)
end

--- Entity.chooserShortcuts
--- Variable
--- A list of shortcuts that can be used when the chooser is visible. The following shortcuts are available by default:
---  * <kbd>^k</kbd> to navigate up an item
---  * <kbd>^j</kbd> to navigate down an item
---  * <kbd>^u</kbd> to navigate a page of rows up
---  * <kbd>^d</kbd> to navigate a page of rows down
Entity.chooserShortcuts = {
    { { "ctrl" }, "j", function(chooser)
        chooser:selectedRow(chooser:selectedRow() + 1)
        return true
    end },
    { { "ctrl" }, "k", function(chooser)
        chooser:selectedRow(chooser:selectedRow() - 1)
        return true
    end },
    { { "ctrl" }, "d", function(chooser)
        chooser:selectedRow(chooser:selectedRow() + chooser:rows())
        return true
    end },
    { { "ctrl" }, "u", function(chooser)
        chooser:selectedRow(chooser:selectedRow() - chooser:rows())
        return true
    end },
}

--- Entity:registerChooserShortcuts(shortcuts, override) -> table of registered shortcuts
--- Method
--- Registers a list of chooser shortcuts with the option of merging with the existing [default](#chooserShortcuts) or previously initialized chooser shortcuts.
---
--- Parameters:
---  * `shortcuts` - The list of shortcut objects. Shortcut event handlers will be invoked with the [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) instance:
---    ```
---    { { "ctrl" }, "j", function(chooser) chooser:selectedRow(chooser:selectedRow() + 1) end },
---    { { "ctrl" }, "k", function(chooser) chooser:selectedRow(chooser:selectedRow() - 1) end },
---    ```
---  * `override` - A boolean denoting to whether to override the existing chooser shortcuts
---
--- Returns:
---   * `shortcuts` - Returns the list of registered chooser shortcuts
function Entity:registerChooserShortcuts(shortcuts, override)
    local existingShortcuts = self.chooserShortcuts or {}
    self.chooserShortcuts = override and shortcuts or self:mergeShortcuts(shortcuts, existingShortcuts)
    return self.chooserShortcuts
end

--- Entity.chooser
--- Variable
--- The chooser [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) instance or `nil` if not active.
Entity.chooser = nil

--- Entity:loadChooserRowImages(choices[, reload])
--- Method
--- For a given set of choices, asynchronously loads images from an `imageURL` key for each choice object and refreshes the callback for a chooser with a choices callback.
---
--- Parameters:
---  * `choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects
---  * `reload` - An optional boolean value to pass to [`hs.chooser:refreshChoicesCallback`](http://www.hammerspoon.org/docs/hs.chooser.html#refreshChoicesCallback). Defaults to `true`.
---
--- Returns:
---  * None
function Entity:loadChooserRowImages(choices, reload)
    reload = reload == nil and true or reload

    -- Initialize lists of indexes that share the same image URL
    local indexesByImageURL = {}
    for i = 1, #choices do
        local choice = choices[i]
        if choice.imageURL then
            indexesByImageURL[choice.imageURL] = indexesByImageURL[choice.imageURL] or {}
            table.insert(indexesByImageURL[choice.imageURL], i)
        end
    end

    -- Asynchronously load sets of image URLs
    for imageURL, indexes in pairs(indexesByImageURL) do
        hs.image.imageFromURL(imageURL, function(image)
            if not self.chooser then
                return
            end

            for i = 1, #indexes do
                local index = indexes[i]
                choices[index].image = image
            end

            local selectedRow = self.chooser:selectedRow()
            self.chooser:refreshChoicesCallback(reload)
            self.chooser:selectedRow(selectedRow)
        end)
    end
end

--- Entity:showChooser(choices, callback[, options])
--- Method
--- Shows a [chooser](http://www.hammerspoon.org/docs/hs.chooser.html) with a list of choices. The chooser can be closed with Escape <kbd>⎋</kbd>.
---
--- Parameters:
---  * `choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser
---  * `callback` - The callback function invoked when a row is selected
---  * `options` - A table containing various options to configure the chooser:
---    * `placeholderText` - Set the placeholder text
---
--- Returns:
---  * The [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) object
function Entity:showChooser(choices, callback, options)
    options = options or {}

    local chooserListener = nil

    local chooser = hs.chooser.new(function(choice)
        self.chooser = nil

        -- Stop chooser listener and invoke the event handler
        chooserListener:stop()
        callback(choice)
    end)

    -- Add default style
    chooser:searchSubText(true)
    chooser:bgDark(true)

    -- Add choices
    chooser:choices(choices)

    -- Dynamically configure the chooser with specified options
    for methodName, args in pairs(options) do
        if type(args) == "table" then
            chooser[methodName](chooser, table.unpack(args))
        else
            chooser[methodName](chooser, args)
        end
    end

    self.chooser = chooser

    -- Create an event listener while the chooser is visible to select rows with ctrl+j/k
    chooserListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyName = hs.keycodes.map[event:getKeyCode()]
        local chooserEventHandler = self.getEventHandler(self.chooserShortcuts, flags, keyName)

        if chooserEventHandler then
            return chooserEventHandler(chooser)
        end
    end)

    -- Start row chooser listener and show the chooser
    chooserListener:start()
    return chooser:show()
end

--- Entity:showActions()
--- Method
--- Opens a chooser populated with actions configured on the entity, which upon selection will trigger the action
---
--- Returns:
---  * None
function Entity:showActions()
    local choices = {}
    local shortcuts = {table.unpack(self.shortcuts)}
    for index, shortcut in pairs(shortcuts) do
        local flags, keyName, _, metadata = table.unpack(shortcut)
        local category, description = table.unpack(metadata or {})
        local shortcutText = glyphs.createShortcutText(flags, keyName)
        local choice = {
            text = description,
            subText = shortcutText ~= glyphs.unmapped.key
                and category.." action ("..shortcutText..")"
                or category,
            index = index,
        }

        table.insert(choices, choice)
    end

    local vowelIndex = self.name:find("[aAeEiIoOuU]")
    local article = vowelIndex and vowelIndex == 1 and "an" or "a"
    local options = { placeholderText = "Trigger "..article.." "..self.name.." action" }

    self:showChooser(choices, function(choice)
        if not choice then return end

        local shortcut = shortcuts[choice.index]
        local flags = shortcut[_G.SHORTCUT_MODKEY_INDEX]
        local keyName = shortcut[_G.SHORTCUT_HOTKEY_INDEX]
        local action = shortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]

        self.behaviors.default(self, action, flags, keyName, {})
    end, options)
end

--- Entity:getEventHandler(shortcuts, flags, keyName) -> function or nil
--- Method
--- Returns the event handler within the provided shortcuts with the given shortcut keybindings, or nil if not found
---
--- Parameters:
---  * `shortcuts` - The list of shortcut objects
---  * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
---  * `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity.getEventHandler(shortcuts, flags, keyName)
    for _, registeredShortcut in pairs(shortcuts) do
        local registeredFlags = registeredShortcut[_G.SHORTCUT_MODKEY_INDEX]
        local registeredKeyName = registeredShortcut[_G.SHORTCUT_HOTKEY_INDEX]
        local registeredHandler = registeredShortcut[_G.SHORTCUT_EVENT_HANDLER_INDEX]
        local areFlagsEqual = flags == registeredFlags or
            (flags and flags.containExactly and flags:containExactly(registeredFlags or {}))

        if areFlagsEqual and keyName == registeredKeyName then
            return registeredHandler
        end
    end

    return nil
end

--- Entity:dispatchAction(mode, shortcut) -> boolean
--- Method
--- Dispatch an action from a shortcut within the context of the given mode
---
--- Parameters:
---  * `mode` - The name of the current mode
---  * `shortcut` - A shortcut object containing the keybindings and event handler for the entity
---  * `workflow` - The list of events that compose the current workflow
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity:dispatchAction(mode, shortcut, workflow)
    local flags = shortcut.flags
    local keyName = shortcut.keyName
    local eventHandler = self.getEventHandler(self.shortcuts, flags, keyName)

    if eventHandler then
        local executeBehavior = self.behaviors[mode] or self.behaviors.default

        return executeBehavior(self, eventHandler, flags, keyName, workflow)
    else
        return self.autoExitMode
    end
end

return Entity
