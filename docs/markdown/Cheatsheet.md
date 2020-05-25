# [docs](index.md) » Cheatsheet
---

Cheatsheet modal used to display registered keyboard shortcuts


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [init](#init)
 * [show](#show)

## API Documentation

### Methods

| [init](#init)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Cheatsheet:init(name, description, shortcuts[, view])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initialize the cheatsheet object                                                                     |
| **Parameters**                              | <ul><li>`name` - The subject of the cheatsheet.</li><li>`description` - The description subtext to be rendered under the cheatsheet name</li><li>`shortcuts` - A table containing the list of shortcuts to display in the cheatsheet</li><li>`view` - An optional [`hs.webview`](https://www.hammerspoon.org/docs/hs.webview.html) instance to set custom styles for the cheatsheet. A titled, closable utility view will be configured with dark mode by default.</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [show](#show)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Cheatsheet:show([iconURL])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Show the cheatsheet modal. Hit Escape <kbd>⎋</kbd> to close.                                                                     |
| **Parameters**                              | <ul><li>`iconURL` - Image source of the cheatsheet icon</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

