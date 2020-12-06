--- === Entity ===
---
--- Entity class that represents some abstract automatable desktop entity
---
local class = require("middleclass")
local lustache = require("lustache")
local Cheatsheet = require("cheatsheet")
local glyphs = require("glyphs")
local Action = require("action")

local Entity = class("Entity")
Entity.unmapped = glyphs.unmapped.text

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
---  * `handler` - the event handler to be invoked within the function
---  * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
---  * `key` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---
--- The table is defined with an `__add` metamethod to overwrite the default entity behaviors.
---
--- Currently supported behaviors:
--- * `default` - triggers the event handler and returns a boolean flag whether to auto-exit back to desktop mode or not, depending on the return value of the handler or the `autoExitMode` variable on the entity class
Entity.behaviors = {
    default = function(self, handler)
        local _, autoExit = handler()

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

-- Create a string shortcut key from its modifier keys and hotkey
function Entity.getShortcutKey(mods, hotkey)
    if not hotkey or not mods then
        return tostring(hotkey)
    end

    local clonedMods = { table.unpack(mods) }
    table.sort(clonedMods)

    return table.concat(clonedMods)..hotkey
end

-- Merge Ki shortcuts with the option of overriding shortcuts
-- Shortcuts with conflicting hotkeys will result in the `toList` shortcut being overwritten by the `fromList` shortcut
function Entity:mergeShortcuts(fromList, toList)
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
    local description = self.name and "Ki shortcut keybindings registered for "..self.name or "Ki shortcut keybindings"

    self.shortcuts = override and shortcuts or self:mergeShortcuts(shortcuts, self.shortcuts or {})

    self.cheatsheet = Cheatsheet:new({
        name = self.name,
        description = description,
        shortcuts = self.shortcuts,
    })

    return self.shortcuts
end

function Entity:Shortcut(...)
    self:registerShortcuts({...})
end

function Entity:Shortcuts(...)
    self:registerShortcuts(...)
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
        local mods = event:getFlags()
        local key = hs.keycodes.map[event:getKeyCode()]
        local chooserHandler = self.getHandler(self.chooserShortcuts, mods, key)

        if chooserHandler then
            return chooserHandler(chooser)
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

    local function createChoice(index, shortcut, category)
        local mods, key, action, name = table.unpack(shortcut)
        local shortcutText = glyphs.createShortcutText(mods, key)

        return {
            text = tostring(action) == "action" and action.name or name,
            subText = shortcutText ~= glyphs.unmapped.key
                and category.." action ("..shortcutText..")"
                or category,
            index = index,
        }
    end

    for key, value in pairs(self.shortcuts) do
        if type(key) == "string" and type(value) == "table" then
            local categoryName, categorizedShortcuts = key, value
            for index, shortcut in pairs(categorizedShortcuts) do
                table.insert(choices, createChoice(index, shortcut, categoryName))
            end
        else
            local index, shortcut = key, value
            table.insert(choices, createChoice(index, shortcut, self.name))
        end
    end

    local vowelIndex = self.name:find("[aAeEiIoOuU]")
    local article = vowelIndex and vowelIndex == 1 and "an" or "a"
    local options = { placeholderText = "Trigger "..article.." "..self.name.." action" }

    self:showChooser(choices, function(choice)
        if not choice then return end

        local shortcut = self.shortcuts[choice.index]
        local mods, key, action = table.unpack(shortcut)

        self.behaviors.default(self, action, mods, key, {})
    end, options)
end

--- Entity:getHandler(shortcuts, flags, key) -> function or nil
--- Method
--- Returns the event handler within the provided shortcuts with the given shortcut keybindings, or nil if not found
---
--- Parameters:
---  * `shortcuts` - The list of shortcut objects
---  * `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)
---  * `key` - A string containing the name of a keyboard key (in `hs.keycodes.map`)
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity.getHandler(shortcuts, mods, key)
    local function getHandler(registeredShortcut)
        local registeredMods, registeredKey, registeredHandler = table.unpack(registeredShortcut)
        local areModsEqual = mods == registeredMods
            or registeredMods ~= glyphs.unmapped.text and
            (mods and mods.containExactly and mods:containExactly(registeredMods or {}))

        if areModsEqual and key == registeredKey then
            return registeredHandler
        end
    end

    for k, value in pairs(shortcuts) do
        if type(k) == "string" and type(value) == "table" then
            local categorizedShortcuts = value
            for _, registeredShortcut in pairs(categorizedShortcuts) do
                local registeredHandler = getHandler(registeredShortcut)
                if registeredHandler then
                    return registeredHandler
                end
            end
        else
            local registeredShortcut = value
            local registeredHandler = getHandler(registeredShortcut)
            if registeredHandler then
                return registeredHandler
            end
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
---  * `command` - The list of events that compose the current command
---
--- Returns:
---  * A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched
function Entity:dispatchAction(mode, shortcut, command)
    local mods = shortcut.mods
    local key = shortcut.key
    local handler = self.getHandler(self.shortcuts, mods, key)

    if handler then
        local executeBehavior = self.behaviors[mode] or self.behaviors.default

        return executeBehavior(self, handler, mods, key, command)
    else
        return self.autoExitMode
    end
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
    if type(options) == "string" then
        self.name = options
    elseif #options > 0 then
        self.name, self.shortcuts, self.autoExitMode = table.unpack(options)
    else
        for key, option in pairs(options) do
            self[key] = option
        end
    end

    -- Default mode auto-exit flag to true
    self.autoExitMode = self.autoExitMode == nil and true or self.autoExitMode

    local showActions = Action {
        name = "Show Actions",
        action = function(...)
            self:showActions(...)
        end,
    }
    local showCheatsheet = Action {
        name = "Show Cheatsheet",
        action = function(...)
            self.cheatsheet:show(...)
        end,
    }

    local mergedShortcuts = self:mergeShortcuts(self.shortcuts or {}, {
        { { "cmd" }, "space", showActions },
        { { "shift" }, "/", showCheatsheet },
    })

    self:registerShortcuts(mergedShortcuts)
    self:registerChooserShortcuts(self.chooserShortcuts)
end

return Entity
