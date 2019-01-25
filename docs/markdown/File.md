# [docs](index.md) » File
---

File class that subclasses [Entity](Entity.html) to represent some directory or file


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
* Methods - API calls which can only be made on an object returned by a constructor
 * [createEvent](#createEvent)
 * [getFileIcon](#getFileIcon)
 * [initialize](#initialize)
 * [moveToTrash](#moveToTrash)
 * [navigate](#navigate)
 * [open](#open)
 * [openInfoWindow](#openInfoWindow)
 * [openWith](#openWith)
 * [showFileSelectionModal](#showFileSelectionModal)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | File [behaviors](Entity.html#behaviors) defined to invoke event handlers with the file path.                                                                     |

### Methods

| [createEvent](#createEvent)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:createEvent(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Convenience method to create file events that share the similar behavior of allowing navigation before item selection                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of a file</li></ul> |
| **Returns**                                 | <ul><li> An event handler function</li></ul>          |

| [getFileIcon](#getFileIcon)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:getFileIcon(path)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Retrieves an icon image for the given file path or returns nil if not found                                                                     |
| **Parameters**                              | <ul><li>`path` - The path of a file</li></ul> |
| **Returns**                                 | <ul><li> The file icon [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html) object</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:initialize(path, shortcuts)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new file instance with its path and custom shortcuts. By default, a cheatsheet and common shortcuts are initialized.                                                                     |
| **Parameters**                              | <ul><li>`path` - The initial directory path</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the file entity</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

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

| [showFileSelectionModal](#showFileSelectionModal)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `File:showFileSelectionModal(path, handler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a selection modal with a list of files at a given path.                                                                     |
| **Parameters**                              | <ul><li>`path` - the path of the directory that should have its file contents listed in the selection modal</li><li>`handler` - the selection event handler function that takes in the following arguments:</li><li>   `targetPath` - the selected target path</li><li>   `shouldTriggerAction` - a boolean value to ensure the action is triggered</li></ul> |
| **Returns**                                 | <ul><li> A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects</li></ul>          |
