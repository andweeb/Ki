# [docs](index.md) » hs._asm.undocumented.spaces
---

These functions utilize private API's within the OS X internals, and are known to have unpredictable behavior under Mavericks and Yosemite when "Displays have separate Spaces" is checked under the Mission Control system preferences.


## API Overview
* Functions - API calls offered directly by the extension
 * [count](#count)
 * [currentSpace](#currentSpace)
 * [isAnimating](#isAnimating)
 * [moveToSpace](#moveToSpace)
 * [screensHaveSeparateSpaces](#screensHaveSeparateSpaces)

## API Documentation

### Functions

| [count](#count)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `hs._asm.undocumented.spaces.count() -> number`                                                                    |
| **Type**                                    | Function                                                                     |
| **Description**                             | LEGACY: The number of spaces you currently have.                                                                     |
| **Notes**                                   | <ul><li>this function may go away in a future update</li></ul>                |

| [currentSpace](#currentSpace)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `hs._asm.undocumented.spaces.currentSpace() -> number`                                                                    |
| **Type**                                    | Function                                                                     |
| **Description**                             | LEGACY: The index of the space you're currently on, 1-indexed (as usual).                                                                     |
| **Notes**                                   | <ul><li>this function may go away in a future update</li></ul>                |

| [isAnimating](#isAnimating)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `hs._asm.undocumented.spaces.isAnimating([screen]) -> bool`                                                                    |
| **Type**                                    | Function                                                                     |
| **Description**                             | Returns the state of space changing animation for the specified monitor, or for any monitor if no parameter is specified.                                                                     |
| **Parameters**                              | <ul><li>screen - an optional hs.screen object specifying the specific monitor to check the animation status for.</li></ul> |
| **Returns**                                 | <ul><li>a boolean value indicating whether or not a space changing animation is currently active.</li></ul>          |
| **Notes**                                   | <ul><li>This function can be used in `hs.eventtap` based space changing functions to determine when to release the mouse and key events.</li></ul>                |

| [moveToSpace](#moveToSpace)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `hs._asm.undocumented.spaces.moveToSpace(number)`                                                                    |
| **Type**                                    | Function                                                                     |
| **Description**                             | LEGACY: Switches to the space at the given index, 1-indexed (as usual).                                                                     |
| **Notes**                                   | <ul><li>this function may go away in a future update</li></ul>                |

| [screensHaveSeparateSpaces](#screensHaveSeparateSpaces)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `hs._asm.undocumented.spaces.screensHaveSeparateSpaces() -> bool`                                                                    |
| **Type**                                    | Function                                                                     |
| **Description**                             | Determine if the user has enabled the "Displays Have Separate Spaces" option within Mission Control.                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>true or false representing the status of the "Displays Have Separate Spaces" option within Mission Control.</li></ul>          |
| **Notes**                                   | <ul><li>This function uses standard OS X APIs and is not likely to be affected by updates or patches.</li></ul>                |

