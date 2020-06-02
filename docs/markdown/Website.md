# [docs](index.md) » Website
---

Website class that subclasses [Entity](Entity.html) to represent some automatable website entity


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
 * [displaySelectionModalIcons](#displaySelectionModalIcons)
 * [links](#links)
* Methods - API calls which can only be made on an object returned by a constructor
 * [getDomain](#getDomain)
 * [getFaviconURL](#getFaviconURL)
 * [getSelectionItems](#getSelectionItems)
 * [initialize](#initialize)
 * [open](#open)
 * [openWith](#openWith)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | Website [behaviors](Entity.html#behaviors) defined to invoke event handlers with the URL of the website.                                                                     |

| [displaySelectionModalIcons](#displaySelectionModalIcons)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website.displaySelectionModalIcons`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A boolean value to specify whether to show favicons in the selection modal or not. Defaults to `true`.                                                                     |

| [links](#links)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website.links`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | An array of website links used in the default [`Website:getSelectionItems`](#getSelectionItems) method (defaults to an empty list). Any of the following values can be inserted:                                                                     |

### Methods

| [getDomain](#getDomain)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:getDomain(url) -> string or `nil``                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Parses and returns the domain part of the url argument                                                                     |
| **Parameters**                              | <ul><li>`url` - The url string</li></ul> |
| **Returns**                                 | <ul><li> The string domain of the url or `nil`</li></ul>          |

| [getFaviconURL](#getFaviconURL)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:getFaviconURL(url[, size]) -> string or `nil``                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns a URL pointing to a given URL's favicon using Favicon Kit                                                                     |
| **Parameters**                              | <ul><li>`url` - The url string</li><li>`size` - The pixel size of the favicon, i.e. `32` for a 32x32 favicon. Defaults to `48`.</li></ul> |
| **Returns**                                 | <ul><li> The string domain of the url or `nil`</li></ul>          |

| [getSelectionItems](#getSelectionItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:getSelectionItems() -> table of choices or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Generates a list of selection items using the instance's [`Website.links`](Website.html#links) list. Each item will display the page favicon if the [`Website.displaySelectionModalIcons`](Website.html#displaySelectionModalIcons) option is set to `true`.                                                                     |
| **Returns**                                 | <ul><li> A list of choice objects</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:initialize(name, url, links, shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new website entity instance with its name, url, links, and custom shortcuts.                                                                     |
| **Parameters**                              | <ul><li>`name` - The name of the website</li><li>`url` - The website URL</li><li>`links` - Related links to initialize [`Website.links`](#links)</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the url entity</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [open](#open)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:open(url)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens the url                                                                     |
| **Parameters**                              | <ul><li>`url` - the address of the url to open</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [openWith](#openWith)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Website:openWith(url)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a URL with an application selected from a modal                                                                     |
| **Parameters**                              | <ul><li>`url` - the target url that should be opened with the selected application</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

