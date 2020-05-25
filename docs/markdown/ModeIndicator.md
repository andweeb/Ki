# [docs](index.md) » ModeIndicator
---

Mode indicator implementation that displays the current Ki mode in a menubar item


## API Overview
* Variables - Configurable values
 * [isDarkMode](#isDarkMode)
* Methods - API calls which can only be made on an object returned by a constructor
 * [show](#show)

## API Documentation

### Variables

| [isDarkMode](#isDarkMode)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ModeIndicator.isDarkMode`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A boolean value indicating whether the menu bar style is in dark mode. This value will be determined automatically.                                                                     |

### Methods

| [show](#show)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ModeIndicator:show(mode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a text display on center of the menu bar to indicate the current mode                                                                     |
| **Parameters**                              | <ul><li>`mode` - a string value containing the current mode (i.e., `"normal"`, `"entity"`, etc.)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

