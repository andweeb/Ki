# [docs](index.md) » Application
---

Application class that subclasses [Entity](Entity.html) to represent some automatable desktop application


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [createMenuItemEvent](#createMenuItemEvent)
 * [dispatchAction](#dispatchAction)
 * [getApplication](#getApplication)
 * [getMenuItemList](#getMenuItemList)
 * [initialize](#initialize)
 * [invokeEventHandler](#invokeEventHandler)

## API Documentation

### Methods

| [createMenuItemEvent](#createMenuItemEvent)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.createMenuItemEvent(menuItem[, shouldFocusAfter, shouldFocusBefore])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to create an event handler that selects a menu item, with optionally specified behavior on how the menu item selection occurs                                                                     |
| **Parameters**                              | <ul><li>`menuItem` - the menu item to select, specified as either a string or a table</li><li>`options` - a optional table containing some or all of the following fields to define the behavior for the menu item selection event:</li><li>   `isRegex` - a boolean denoting whether there is a regular expression within the menu item name(s)</li><li>   `isToggleable` - a boolean denoting whether the menu item parameter is passed in as a list of two items to toggle between, i.e., `{ "Play", "Pause" }`</li><li>   `focusBefore` - an optional boolean denoting whether to focus the application before the menu item is selected</li><li>   `focusAfter` - an optional boolean denoting whether to focus the application after the menu item is selected</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [dispatchAction](#dispatchAction)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:dispatchAction(mode, shortcut) -> boolean`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Dispatch an action from a triggered shortcut for an entity                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the current mode</li><li>`shortcut` - A shortcut object with an action to invoke on the entity</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [getApplication](#getApplication)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:getApplication() -> hs.application object or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object from the entity name                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An `hs.application` object or `nil` if the application could not be found</li></ul>          |

| [getMenuItemList](#getMenuItemList)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.getMenuItemList(app, menuItemPath) -> table or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets a list of menu items from a hierarchical menu item path                                                                     |
| **Parameters**                              | <ul><li>`app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`menuItemPath` - A table representing the hierarchical path of the target menu item (e.g. `{ "File", "Share" }`)</li></ul> |
| **Returns**                                 | <ul><li> A list of [menu items](https://www.hammerspoon.org/docs/hs.application.html#getMenuItems) or `nil`</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:initialize(name, shortcuts, autoExitMode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new application instance with its name and shortcuts. By default, common shortcuts are automatically registered, and the initialized [entity](Entity.html) defaults, such as the cheatsheet.                                                                     |
| **Parameters**                              | <ul><li>`name` - The entity name</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the entity</li><li>`autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [invokeEventHandler](#invokeEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:invokeEventHandler(app, mode, eventHandler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Invokes an action with different parameters depending on the current Ki mode                                                                     |
| **Parameters**                              | <ul><li>`app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`mode` - The current mode name</li><li>`eventHandler` - The action event handler</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

