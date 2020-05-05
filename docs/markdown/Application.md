# [docs](index.md) » Application
---

Application class that subclasses [Entity](Entity.html) to represent some automatable desktop application


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
* Methods - API calls which can only be made on an object returned by a constructor
 * [createMenuItemEvent](#createMenuItemEvent)
 * [createMenuItemSelectionEvent](#createMenuItemSelectionEvent)
 * [focus](#focus)
 * [getApplication](#getApplication)
 * [getMenuItemList](#getMenuItemList)
 * [getSelectionItems](#getSelectionItems)
 * [initialize](#initialize)
 * [toggleFullScreen](#toggleFullScreen)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | Application [behaviors](Entity.html#behaviors) defined to invoke event handlers with `hs.application`.                                                                     |

### Methods

| [createMenuItemEvent](#createMenuItemEvent)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.createMenuItemEvent(menuItem[, shouldFocusAfter, shouldFocusBefore])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to create an event handler that selects a menu item, with optionally specified behavior on how the menu item selection occurs                                                                     |
| **Parameters**                              | <ul><li>`menuItem` - the menu item to select, specified as either a string or a table</li><li>`options` - a optional table containing some or all of the following fields to define the behavior for the menu item selection event:</li><li>   `isRegex` - a boolean denoting whether there is a regular expression within the menu item name(s)</li><li>   `isToggleable` - a boolean denoting whether the menu item parameter is passed in as a list of two items to toggle between, i.e., `{ "Play", "Pause" }`</li><li>   `focusBefore` - an optional boolean denoting whether to focus the application before the menu item is selected</li><li>   `focusAfter` - an optional boolean denoting whether to focus the application after the menu item is selected</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [createMenuItemSelectionEvent](#createMenuItemSelectionEvent)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.createMenuItemSelectionEvent(menuItem[, shouldFocusAfter, shouldFocusBefore])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to create an event handler that presents a selection modal containing menu items that are nested/expandable underneath at the provided `menuItem` path, with optionally specified behavior on how the menu item selection occurs                                                                     |
| **Parameters**                              | <ul><li>`menuItem` - a table list of strings that represent a path to a menu item that expands to menu item list, i.e., `{ "File", "Open Recent" }`</li><li>`options` - a optional table containing some or all of the following fields to define the behavior for the menu item selection event:</li><li>   `focusBefore` - an optional boolean denoting whether to focus the application before the menu item is selected</li><li>   `focusAfter` - an optional boolean denoting whether to focus the application after the menu item is selected</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [focus](#focus)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:focus(app[, choice])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Activates an application or focuses a specific application window or tab                                                                     |
| **Parameters**                              | <ul><li>`app` - the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`choice` - an optional [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) object, each with a `windowId` field and (optional) `tabIndex` field</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [getApplication](#getApplication)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:getApplication() -> hs.application object or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object from the instance name                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An `hs.application` object or `nil` if the application could not be found</li></ul>          |

| [getMenuItemList](#getMenuItemList)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application.getMenuItemList(app, menuItemPath) -> table or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Gets a list of menu items from a hierarchical menu item path                                                                     |
| **Parameters**                              | <ul><li>`app` - The target [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li><li>`menuItemPath` - A table representing the hierarchical path of the target menu item (e.g. `{ "File", "Share" }`)</li></ul> |
| **Returns**                                 | <ul><li> A list of [menu items](https://www.hammerspoon.org/docs/hs.application.html#getMenuItems) or `nil`</li></ul>          |

| [getSelectionItems](#getSelectionItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:getSelectionItems()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Default implementation of [`Entity:getSelectionItems()`](Entity.html#getSelectionItems) to returns choice objects containing application window information.                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:initialize(name, shortcuts, autoExitMode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new application instance with its name and shortcuts. By default, common shortcuts are automatically registered, and the initialized [entity](Entity.html) defaults, such as the cheatsheet.                                                                     |
| **Parameters**                              | <ul><li>`name` - The entity name</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the entity</li><li>`autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [toggleFullScreen](#toggleFullScreen)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Application:toggleFullScreen(app)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Toggles the full screen state of the focused application window                                                                     |
| **Parameters**                              | <ul><li>`app` - the [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object</li></ul> |
| **Returns**                                 | <ul><li> `true`</li></ul>          |

