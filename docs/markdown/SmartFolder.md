# [docs](index.md) » SmartFolder
---

SmartFolder class that subclasses [File](File.html) to represent a [smart folder](https://support.apple.com/kb/PH25589) to be automated


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [copy](#copy)
 * [initialize](#initialize)
 * [move](#move)
 * [moveToTrash](#moveToTrash)
 * [openFile](#openFile)
 * [openFileWith](#openFileWith)
 * [openInfoWindow](#openInfoWindow)
 * [showFileSearchChooser](#showFileSearchChooser)

## API Documentation

### Methods

| [copy](#copy)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:copy(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Copies a file in the smart folder search results to different folder                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:initialize(path, shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new smart folder entity instance with its search criteria file and custom shortcuts. By default, a cheatsheet and default shortcuts are initialized.                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the smart folder entity</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [move](#move)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:move(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Moves a selected file in the smart folder to a different folder                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [moveToTrash](#moveToTrash)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:moveToTrash(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Moves a selected file in the smart folder search results to the Trash                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [openFile](#openFile)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:openFile(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Open a file from the smart folder search results                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [openFileWith](#openFileWith)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:openFileWith(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Open a file selected from the smart folder search results with a specific application                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [openInfoWindow](#openInfoWindow)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:openInfoWindow(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a Finder information window for the file selected from the smart folder search results                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [showFileSearchChooser](#showFileSearchChooser)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `SmartFolder:showFileSearchChooser(path, callback)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a chooser with smart folder search result choices                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of the smart folder (`.savedSearch` file)</li><li>`callback` - The callback function invoked on a file selection with a choice object created from [`File.createFileChoices`](File.html#createFileChoices)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

