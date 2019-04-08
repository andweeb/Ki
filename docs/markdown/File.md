# [docs](index.md) » File
---

File class that subclasses [Entity](Entity.html) to represent some directory or file to be automated


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
* Methods - API calls which can only be made on an object returned by a constructor
 * [copy](#copy)
 * [createEvent](#createEvent)
 * [createFileChoices](#createFileChoices)
 * [getFileIcon](#getFileIcon)
 * [initialize](#initialize)
 * [move](#move)
 * [moveToTrash](#moveToTrash)
 * [navigate](#navigate)
 * [open](#open)
 * [openInfoWindow](#openInfoWindow)
 * [openWith](#openWith)
 * [runFileModeApplescript](#runFileModeApplescript)
 * [showFileSelectionModal](#showFileSelectionModal)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | File [behaviors](Entity.html#behaviors) defined to invoke event handlers with the file path.                                                                     |

### Methods

| [copy](#copy)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:copy(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Method to copy one file into a directory. Opens a navigation modal for selecting the target file, then on selection opens another navigation modal to select the destination path. A confirmation dialog is presented to proceed with copying the file to the target directory.                                                                     |
| **Parameters**                              | <ul><li>`path` - the initial directory path to select a target file to copy</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [createEvent](#createEvent)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:createEvent(path) -> function`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to create file events that share the similar behavior of allowing navigation before item selection                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of a file</li></ul> |
| **Returns**                                 | <ul><li> An event handler function</li></ul>          |

| [createFileChoices](#createFileChoices)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File.createFileChoices(fileListIterator, createText, createSubText) -> choice object list`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Creates a list of choice objects each representing the file walked with the provided iterator                                                                     |
| **Parameters**                              | <ul><li>`fileListIterator` - an iterator to walk a list of file paths, i.e. `s:gmatch(pattern)`</li><li>`createText` - an optional function that takes in a single `path` argument to return a formatted string to assign to the `text` field in each file choice object</li><li>`createSubText` - an optional function that takes in a single `path` argument to return a formatted string to assign to the `subText` field in each file choice object</li></ul> |
| **Returns**                                 | <ul><li> `choices` - A list of choice objects each containing the following fields:</li><li>   `text` - The primary chooser text string</li><li>   `subText` - The chooser subtext string</li><li>   `fileName` - The name of the file</li><li>   `path` - The path of the file</li></ul>          |

| [getFileIcon](#getFileIcon)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:getFileIcon(path) -> [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Retrieves an icon image for the given file path or returns `nil` if not found                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of a file</li></ul> |
| **Returns**                                 | <ul><li> The file icon [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html) object</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:initialize(path, shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new file instance with its path and custom shortcuts. By default, a cheatsheet and common shortcuts are initialized.                                                                     |
| **Parameters**                              | <ul><li>`path` - The initial directory path</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the file entity</li><li>`options` - A table containing various options that configures the file instance</li><li>  `showHiddenFiles` - A flag to display hidden files in the file selection modal. Defaults to `false`</li><li>  `sortAttribute` - The file attribute to sort the file selection list by. File attributes come from [hs.fs.dir](http://www.hammerspoon.org/docs/hs.fs.html#dir). Defaults to `modification` (last modified timestamp)</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [move](#move)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:move(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Method to move one file into a directory. Opens a navigation modal for selecting the target file, then on selection opens another navigation modal to select the destination path. A confirmation dialog is presented to proceed with moving the file to the target directory.                                                                     |
| **Parameters**                              | <ul><li>`path` - the initial directory path to select a target file to move</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [moveToTrash](#moveToTrash)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:moveToTrash(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Moves a file or directory at the given path to the Trash. A dialog block alert opens to confirm before proceeding with the operation.                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the target file to move to the trash</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [navigate](#navigate)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:navigate(path, handler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Recursively navigates through parent and child directories until a selection is made                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the target file</li><li>`handler` - the selection callback handler function invoked with the following arguments:</li><li>  `targetFilePath` - the target path of the selected file</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [open](#open)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:open(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a file or directory at the given path                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the target file to open</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [openInfoWindow](#openInfoWindow)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:openInfoWindow(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a Finder information window for the file at `path`                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the target file</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [openWith](#openWith)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:openWith(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a file or directory at the given path with a specified application and raises the application to the front                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the target file to open</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [runFileModeApplescript](#runFileModeApplescript)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:runFileModeApplescript(viewModel)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to render and run the `file-mode-operations.applescript` file and notify on execution errors. Refer to the applescript template file itself to see available view model records.                                                                     |
| **Parameters**                              | <ul><li>`viewModel` - The view model object used to render the template</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [showFileSelectionModal](#showFileSelectionModal)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:showFileSelectionModal(path, handler) -> [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) object list`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a selection modal with a list of files at a given path.                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the directory that should have its file contents listed in the selection modal</li><li>`handler` - the selection event handler function that takes in the following arguments:</li><li>   `targetPath` - the selected target path</li><li>   `shouldTriggerAction` - a boolean value to ensure the action is triggered</li></ul> |
| **Returns**                                 | <ul><li> A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects</li></ul>          |

