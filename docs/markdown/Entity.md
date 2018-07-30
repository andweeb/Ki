# [docs](index.md) » Entity
---

Entity class that represents automatable desktop entities, i.e., applications, desktop spaces, Siri, etc.


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [dispatchAction](#dispatchAction)
 * [getApplication](#getApplication)
 * [getMenuItemList](#getMenuItemList)
 * [getSelectionItems](#getSelectionItems)
 * [initialize](#initialize)
 * [invokeEventHandler](#invokeEventHandler)
 * [mergeShortcuts](#mergeShortcuts)
 * [notifyError](#notifyError)
 * [registerShortcuts](#registerShortcuts)
 * [renderScriptTemplate](#renderScriptTemplate)
 * [showSelectionModal](#showSelectionModal)

## API Documentation

### Methods

| [dispatchAction](#dispatchAction)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:dispatchAction(mode, shortcut) -> boolean`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Dispatch an action from a triggered shortcut for an entity                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the current mode</li><li>`shortcut` - A shortcut object with an action to invoke on the entity</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [getApplication](#getApplication)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getApplication() -> hs.application object or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object from the entity name                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An `hs.application` object or `nil` if the application could not be found</li></ul>          |

| [getMenuItemList](#getMenuItemList)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.getMenuItemList(app, menuItemPath) -> table or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets a list of menu items from a hierarchical menu item path                                                                     |
| **Parameters**                              | <ul><li>`app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`menuItemPath` - A table representing the hierarchical path of the target menu item (e.g. `{ "File", "Share" }`)</li></ul> |
| **Returns**                                 | <ul><li> A list of [menu items](https://www.hammerspoon.org/docs/hs.application.html#getMenuItems) or `nil`</li></ul>          |

| [getSelectionItems](#getSelectionItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getSelectionItems(appName) -> table of choices or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | A placeholder method to return a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects for the selection modal. Subclassed entities intended to be used with select mode must implement this method to correctly display items in the selection modal.                                                                     |
| **Parameters**                              | <ul><li>`appName` - The entity application name</li></ul> |
| **Returns**                                 | <ul><li> `selectionItems` - A list of choices or `nil`</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:initialize(name, shortcuts, autoExitMode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new entity instance with its name and available shortcuts. By default, a `cheatsheet` object will be initialized on the entity object with the provided shortcut keybindings, and dispatched actions will automatically exit the current mode by default unless `autoExitMode` is explicitly set to `false`.                                                                     |
| **Parameters**                              | <ul><li>`name` - The entity name</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the entity</li><li>`autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [invokeEventHandler](#invokeEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:invokeEventHandler(app, mode, eventHandler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Invokes an action with different parameters depending on the current Ki mode                                                                     |
| **Parameters**                              | <ul><li>`app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`mode` - The current mode name</li><li>`eventHandler` - The action event handler</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [mergeShortcuts](#mergeShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.mergeShortcuts(fromList, toList) -> table`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Merges lists of shortcuts based on their keybindings                                                                     |
| **Parameters**                              | <ul><li>`fromList` - The list of shortcuts to apply onto the second list argument</li><li>`toList` - The target list of shortcuts to override those in the first list argument</li></ul> |
| **Returns**                                 | <ul><li> `list` - The list of merged shortcut objects</li></ul>          |

| [notifyError](#notifyError)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.notifyError(message, details)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Displays error details in a notification and logs to the Hammerspoon console                                                                     |
| **Parameters**                              | <ul><li>`message` - The main notification message</li><li>`details` - The textual body of the notification containing details of the error</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [registerShortcuts](#registerShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:registerShortcuts(shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers the list of shortcuts applicable to the entity object                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcuts for the entity</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [renderScriptTemplate](#renderScriptTemplate)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.renderScriptTemplate(scriptName[, viewModel]) -> string`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Generates an applescript template string with a given view model object                                                                     |
| **Parameters**                              | <ul><li>`scriptName` - The applescript file name</li><li>`viewModel` - An optional [lustache](http://olivinelabs.com/lustache/) view model</li></ul> |
| **Returns**                                 | <ul><li>The rendered script string</li></ul>          |

| [showSelectionModal](#showSelectionModal)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.showSelectionModal(app, choices, selectEventHandler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a selection modal with a list of choices. Highlight items up and down with <kbd>⌃j</kbd> and <kbd>⌃k</kbd>, and close the modal with <kbd>Escape</kbd>.                                                                     |
| **Parameters**                              | <ul><li>`app` - The [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object for the entity or nil</li><li>`choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser modal</li><li>`selectEventHandler` - The callback function invoked when a choice is selected from the modal</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

