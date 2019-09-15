--- === Entity ===
---
--- Entity class that represents some abstract automatable desktop entity
---

local luaVersion = _VERSION:match("%d+%.%d+")

-- luacov: disable
if not _G.getSpoonPath then
    function _G.getSpoonPath()
        return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
    end
end

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
        local localScriptPath = _G.getSpoonPath().."/osascripts/"..script..".applescript"
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

--- Entity:initialize(name, shortcuts, autoExitMode)
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
function Entity:initialize(name, shortcuts, autoExitMode)
    self.name = name
    self.autoExitMode = autoExitMode ~= nil and autoExitMode or true
    self.shortcuts = shortcuts
    self.cheatsheet = cheatsheet

    local cheatsheetDescription = "Ki shortcut keybindings registered for "..self.name
    self.cheatsheet:init(self.name, cheatsheetDescription, self.shortcuts)
end

--- Entity.mergeShortcuts(fromList, toList) -> table
--- Method
--- Merges lists of shortcuts based on their keybindings
---
--- Parameters:
---  * `fromList` - The list of shortcuts to apply onto the second list argument
---  * `toList` - The target list of shortcuts to override with those in the first list argument with conflicting keybindings
---
--- Returns:
---   * `list` - The list of merged shortcut objects
function Entity.mergeShortcuts(fromList, toList)
    if not fromList or #fromList == 0 then
        return toList
    end

    for _, shortcut in pairs(fromList) do
        local modifierKeys = shortcut[_G.SHORTCUT_MODKEY_INDEX] or {}
        local hotkey = shortcut[_G.SHORTCUT_HOTKEY_INDEX]
        local overrideIndex = nil

        for index, registeredAction in pairs(toList) do
            local registeredModifierKeys = registeredAction[_G.SHORTCUT_MODKEY_INDEX] or {}
            local registeredHotkey = registeredAction[_G.SHORTCUT_HOTKEY_INDEX]

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

--- Entity:getSelectionItems() -> table of choices or nil
--- Method
--- Returns a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display in the selection modal. Entities intended to be used with select mode must implement this method to correctly display items in the selection modal.
---
--- Returns:
---   * `selectionItems` - A list of choices or `nil`
-- luacov: disable
function Entity:getSelectionItems() -- luacheck: ignore
    return nil
end
-- luacov: enable

--- Entity.triggerAfterConfirmation(question, action)
--- Method
--- Opens a dialog block alert for user confirmation before triggering an action
---
--- Parameters:
---  * `question` - Text to display in the block alert
---  * `action` - The callback function to be invoked after user confirmation
---
--- Returns:
---   * None
function Entity.triggerAfterConfirmation(question, action)
    hs.timer.doAfter(0, function()
        hs.focus()

        local answer = hs.dialog.blockAlert(question, "", "Confirm", "Cancel")

        if answer == "Confirm" then action() end
    end)
end

--- Entity.selectionModalShortcuts
--- Variable
--- A list of shortcuts that can be used when the selection modal is visible. The following shortcuts are available by default:
---  * <kbd>^k</kbd> to navigate up an item
---  * <kbd>^j</kbd> to navigate down an item
---  * <kbd>^u</kbd> to navigate a page of rows up
---  * <kbd>^d</kbd> to navigate a page of rows down
Entity.selectionModalShortcuts = {
    { { "ctrl" }, "j", function(modal) modal:selectedRow(modal:selectedRow() + 1) end },
    { { "ctrl" }, "k", function(modal) modal:selectedRow(modal:selectedRow() - 1) end },
    { { "ctrl" }, "d", function(modal) modal:selectedRow(modal:selectedRow() + modal:rows()) end },
    { { "ctrl" }, "u", function(modal) modal:selectedRow(modal:selectedRow() - modal:rows()) end },
}

--- Entity.showSelectionModal(choices, callback)
--- Method
--- Shows a selection modal with a list of choices. The modal can be closed with Escape <kbd>⎋</kbd>.
---
--- Parameters:
---  * `choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser modal
---  * `callback` - The callback function invoked when a choice is selected from the modal
---
--- Returns:
---  * None
function Entity.showSelectionModal(choices, callback)
    local selectionListener = nil
    local modal = hs.chooser.new(function(choice)
        -- Stop selection listener and invoke the event handler
        selectionListener:stop()
        callback(choice)
    end)

    modal:choices(choices)
    modal:searchSubText(true)
    modal:bgDark(true)

    -- Create an event listener while the chooser is visible to select rows with ctrl+j/k
    selectionListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyName = hs.keycodes.map[event:getKeyCode()]
        local modalEventHandler = Entity.getEventHandler(Entity.selectionModalShortcuts, flags, keyName)

        if modalEventHandler then
            modalEventHandler(modal)
            return true
        end
    end)

    -- Start row selection listener and show the modal
    selectionListener:start()
    modal:show()
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
        local behaviorFunc = self.behaviors[mode] or self.behaviors.default

        return behaviorFunc(self, eventHandler, flags, keyName, workflow)
    else
        return self.autoExitMode
    end
end

return Entity
