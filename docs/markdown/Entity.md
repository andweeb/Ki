# [docs](index.md) » Entity
---

Entity class that represents some generic automatable desktop entity


## API Overview
* Variables - Configurable values
 * [selectionModalShortcuts](#selectionModalShortcuts)
* Methods - API calls which can only be made on an object returned by a constructor
 * [dispatchAction](#dispatchAction)
 * [getEventHandler](#getEventHandler)
 * [getSelectionItems](#getSelectionItems)
 * [initialize](#initialize)
 * [invokeEventHandler](#invokeEventHandler)
 * [mergeShortcuts](#mergeShortcuts)
 * [notifyError](#notifyError)
 * [renderScriptTemplate](#renderScriptTemplate)
 * [showSelectionModal](#showSelectionModal)

## API Documentation

### Variables

| [selectionModalShortcuts](#selectionModalShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.selectionModalShortcuts`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A list of shortcuts that can be used when the selection modal is visible. The following shortcuts are available by default:                                                                     |

### Methods

| [dispatchAction](#dispatchAction)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:dispatchAction(mode, shortcut) -> boolean`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Dispatch an action from a shortcut within the context of the given mode                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the current mode</li><li>`shortcut` - A shortcut object containing the keybindings and event handler for the entity</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [getEventHandler](#getEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getEventHandler(shortcuts, flags, keyName)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns the event handler within the provided shortcuts with the given shortcut keybindings, or nil if not found                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcut objects</li><li>`flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)</li><li>`keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [getSelectionItems](#getSelectionItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getSelectionItems() -> table of choices or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display in the selection modal. Entities intended to be used with select mode must implement this method to correctly display items in the selection modal.                                                                     |
| **Returns**                                 | <ul><li> `selectionItems` - A list of choices or `nil`</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:initialize(name, shortcuts, autoExitMode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new entity instance with its name and shortcuts. By default, a `cheatsheet` object will be initialized on the entity object with metadata in the provided shortcut keybindings, and dispatched actions will automatically exit the current mode by default unless the `autoExitMode` parameter is explicitly set to `false`.                                                                     |
| **Parameters**                              | <ul><li>`name` - The entity name</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the entity</li><li>`autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [invokeEventHandler](#invokeEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:invokeEventHandler(mode, eventHandler, ...)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Invokes an action with different parameters depending on the current mode                                                                     |
| **Parameters**                              | <ul><li>`mode` - The current mode name</li><li>`eventHandler` - The action event handler</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [mergeShortcuts](#mergeShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.mergeShortcuts(fromList, toList) -> table`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Merges lists of shortcuts based on their keybindings                                                                     |
| **Parameters**                              | <ul><li>`fromList` - The list of shortcuts to apply onto the second list argument</li><li>`toList` - The target list of shortcuts to override with those in the first list argument with conflicting keybindings</li></ul> |
| **Returns**                                 | <ul><li> `list` - The list of merged shortcut objects</li></ul>          |

| [notifyError](#notifyError)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.notifyError(message, details)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Displays error details in a notification and logs to the Hammerspoon console                                                                     |
| **Parameters**                              | <ul><li>`message` - The main notification message</li><li>`details` - The textual body of the notification containing details of the error</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [renderScriptTemplate](#renderScriptTemplate)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.renderScriptTemplate(scriptName[, viewModel]) -> string`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Generates an applescript from templates located in `src/osascripts` with some view model object                                                                     |
| **Parameters**                              | <ul><li>`scriptName` - The applescript file name</li><li>`viewModel` - An optional [lustache](http://olivinelabs.com/lustache/) view model</li></ul> |
| **Returns**                                 | <ul><li>The rendered script string</li></ul>          |

| [showSelectionModal](#showSelectionModal)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.showSelectionModal(choices, eventHandler, ...)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a selection modal with a list of choices. The modal can be closed with Escape <kbd>⎋</kbd>.                                                                     |
| **Parameters**                              | <ul><li>`choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser modal</li><li>`eventHandler` - The callback function invoked when a choice is selected from the modal</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

