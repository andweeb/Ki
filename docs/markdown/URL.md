# [docs](index.md) » URL
---

URL class that subclasses [Entity](Entity.html) to represent some automatable URL entity


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
 * [displaySelectionModalIcons](#displaySelectionModalIcons)
 * [paths](#paths)
* Methods - API calls which can only be made on an object returned by a constructor
 * [getDomain](#getDomain)
 * [getSelectionItems](#getSelectionItems)
 * [initialize](#initialize)
 * [open](#open)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | URL [behaviors](Entity.html#behaviors) defined to invoke event handlers with the file path.                                                                     |

| [displaySelectionModalIcons](#displaySelectionModalIcons)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL.displaySelectionModalIcons`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A boolean value to specify whether to show favicons in the selection modal or not. Defaults to `true`.                                                                     |

| [paths](#paths)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL.paths`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | An array of sub-paths of the URL or other related URLs. Defaults to an empty list, but it can be overridden to contain any of the following:                                                                     |

### Methods

| [getDomain](#getDomain)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL:getDomain(url) -> string`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Retrieves the domain part of the url argument                                                                     |
| **Parameters**                              | <ul><li>`url` - The url string</li></ul> |
| **Returns**                                 | <ul><li> The string domain of the url or `nil`</li></ul>          |

| [getSelectionItems](#getSelectionItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL:getSelectionItems() -> table of choices or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Generates a list of selection items using the instance's `self.paths` list. Each path item will display the page favicon if the [`URL.displaySelectionModalIcons`](URL.html#displaySelectionModalIcons) option is set to `true`.                                                                     |
| **Returns**                                 | <ul><li> A list of choice objects</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL:initialize(url, shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new url entity instance with its url and custom shortcuts. By default, a cheatsheet and common shortcuts are initialized.                                                                     |
| **Parameters**                              | <ul><li>`url` - The web address that the entity is representing</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the file entity</li><li>`options` - A table containing various options that configures the file instance</li><li>  `selections` - A flag to display hidden files in the file selection modal. Defaults to `false`</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [open](#open)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `URL:open(url)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens the url                                                                     |
| **Parameters**                              | <ul><li>`url` - the address of the url to open</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

