# [docs](index.md) » StatusDisplay
---

Small menubar text display


## API Overview
* Variables - Configurable values
 * [isDarkMode](#isDarkMode)
* Methods - API calls which can only be made on an object returned by a constructor
 * [show](#show)

## API Documentation

### Variables

| [isDarkMode](#isDarkMode)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `StatusDisplay.isDarkMode`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A boolean value indicating whether the menu bar style is in dark mode. This value will be determined automatically.                                                                     |

### Methods

| [show](#show)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `StatusDisplay:show(status[, parenthetical])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a text display on center of the menu bar to indicate the current mode                                                                     |
| **Parameters**                              | <ul><li>`status` - a string value containing the current mode (i.e., `"normal"`, `"entity"`, etc.)</li><li>`parenthetical` - an optional string value of some parenthetical in the text display</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

