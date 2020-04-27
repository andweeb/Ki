# [docs](index.md) » Ki
---

> A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.

### Intro

Ki follows a [modal paradigm](http://vimcasts.org/episodes/modal-editing-undo-redo-and-repeat): as you would edit text objects with operators in vi, you would automate entities with actions in Ki.

Ki provides an API for configuring custom modes and keyboard shortcuts to allow for the automation of any "entity", such as applications, files, websites, windows, smart devices, basically anything that can be programmatically controlled on macOS.

Ki ships with the following core modes:
* `DESKTOP` the default state of macOS
* `NORMAL` a mode in which system and mode transition shortcuts are available
* `ACTION` a mode in which actions can be specified and applied to some entity
* `ENTITY` a mode in which entities are available to be launched or activated

## API Overview
* Constants - Useful values which cannot be changed
 * [Application](#Application)
 * [Entity](#Entity)
 * [File](#File)
 * [SmartFolder](#SmartFolder)
 * [state](#state)
 * [URL](#URL)
* Variables - Configurable values
 * [defaultEntities](#defaultEntities)
 * [statusDisplay](#statusDisplay)
* Methods - API calls which can only be made on an object returned by a constructor
 * [registerModes](#registerModes)
 * [registerShortcuts](#registerShortcuts)
 * [start](#start)
 * [stop](#stop)
 * [useDefaultConfig](#useDefaultConfig)

## API Documentation

### Constants

| [Application](#Application)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.Application`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that subclasses [Entity](Entity.html) to represent some automatable desktop application. Class methods and properties are documented [here](Application.html).                                                                     |

| [Entity](#Entity)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.Entity`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some generic automatable desktop entity. Class methods and properties are documented [here](Entity.html).                                                                     |

| [File](#File)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.File`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some file or directory at an existing file path. Class methods and properties are documented [here](File.html).                                                                     |

| [SmartFolder](#SmartFolder)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.SmartFolder`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some [smart folder](https://support.apple.com/kb/PH25589) at an existing file path. Class methods and properties are documented [here](SmartFolder.html).                                                                     |

| [state](#state)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.state`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | The [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki.                                                                     |

| [URL](#URL)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.URL`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some url. Class methods and properties are documented [here](URL.html).                                                                     |

### Variables

| [defaultEntities](#defaultEntities)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultEntities`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing lists of all default entity instances keyed by mode name when the [default config](#useDefaultConfig) is used, `nil` otherwise.                                                                     |

| [statusDisplay](#statusDisplay)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.statusDisplay`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table that defines the behavior for displaying the status of mode transitions. The `show` function should clear out any previous display and show the current transitioned mode. The following methods should be available on the object:                                                                     |

### Methods

| [registerModes](#registerModes)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:registerModes(stateTransitions, transitionShortcuts) -> table of state transition events, table of transition shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers state events that transition between modes and their assigned keyboard shortcuts.                                                                     |
| **Parameters**                              | <ul><li>`stateTransitions` - A table containing the [state transition events](https://github.com/unindented/lua-fsm#usage) for the finite state machine set to [`Ki.state`](#state).</li></ul> |

| [registerShortcuts](#registerShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:registerShortcuts(shortcuts[, override]) -> table of registered shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers a list of shortcuts for one or more modes.                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcut objects</li><li>`override` - A boolean denoting whether to override existing shortcuts</li></ul> |

| [start](#start)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:start() -> hs.eventtap`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the status display, creates all transition and workflow events, and starts the event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object</li></ul>          |

| [stop](#stop)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:stop() -> hs.eventtap`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Stops the event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object</li></ul>          |

| [useDefaultConfig](#useDefaultConfig)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:useDefaultConfig([options])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Loads the default config                                                                     |
| **Parameters**                              | <ul><li>`options` - A table containing options that configures which default configs to load</li><li>  `include` - A list of entity filenames to load, in which all unspecified entities will not be loaded</li><li>  `exclude` - A list of entity filenames to exclude from loading, in which all unspecified filenames will be loaded</li></ul> |

