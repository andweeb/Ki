# [docs](index.md) » Ki
---

> A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.

### Intro

Ki follows a [modal paradigm](http://vimcasts.org/episodes/modal-editing-undo-redo-and-repeat): as you would edit text objects with operators in vi, you would automate entities with actions in Ki.

Ki provides an API for configuring custom modes and keyboard shortcuts to allow for the automation of any "entity", such as applications, files, websites, windows, smart devices, basically anything that can be programmatically controlled on macOS.

Ki ships with the following core modes:
* `DESKTOP` the default state of macOS
* `NORMAL` a mode in which modes can be entered or actions can be specified
* `ENTITY` a mode in which entities are available to be launched or activated

#### Shortcut Structure

The shortcut table structure is similar to the argument list for binding hotkeys in Hammerspoon:
  1. a list of [modifier keys](http://www.hammerspoon.org/docs/hs.hotkey.html#bind) or `nil`
  2. a string containing the name of a keyboard key (as found in [hs.keycodes.map](http://www.hammerspoon.org/docs/hs.keycodes.html#map))
  3. either an event handler function or an [`Entity`](#Entity) instance (or subclassed entity instance) that implements a [`dispatchAction`](Entity.html#dispatchAction) method to be invoked when the hotkey is pressed. A boolean value can be returned to automatically exit back to `desktop` mode after the action has completed.
  4. a tuple containing metadata about the shortcut: name of the shortcut category and description of the shortcut to be displayed in the cheatsheet

```
-- Example shortcut list:
{
    { nil, "t", function() print("executed action") end, { "Test", "Test print to console" } },
    { { "cmd", "shift" }, "s", Ki.Application:new("Slack"), { "Entities", "Slack" } },
}

-- Explanation:
{
     {
         nil,                                     -- assign hotkey with no modifier key
         "t",                                     -- assign the "t" key
         function() print("executed action") end, -- event handler function
         { "Test", "Test print to console" }      -- shortcut metadata
     },
     {
         { "cmd", "shift" },                      -- assign the command and shift modifier keys
         "s",                                     -- assign the "s" key
         Ki.Application:new("Slack"),             -- initialized Application instance
         { "Entities", "Slack" },                 -- shortcut metadata
     },
}
```

## API Overview
* Constants - Useful values which cannot be changed
 * [Application](#Application)
 * [ApplicationWatcher](#ApplicationWatcher)
 * [Entity](#Entity)
 * [File](#File)
 * [SmartFolder](#SmartFolder)
 * [state](#state)
 * [Website](#Website)
* Variables - Configurable values
 * [defaultEntities](#defaultEntities)
 * [statusDisplay](#statusDisplay)
* Methods - API calls which can only be made on an object returned by a constructor
 * [registerMode](#registerMode)
 * [registerModeShortcuts](#registerModeShortcuts)
 * [registerModeTransition](#registerModeTransition)
 * [remapShortcuts](#remapShortcuts)
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

| [ApplicationWatcher](#ApplicationWatcher)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.ApplicationWatcher`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A module that wraps [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) to track application states. Methods and properties are documented [here](ApplicationWatcher.html).                                                                     |

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

| [Website](#Website)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.Website`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some website. Class methods and properties are documented [here](Website.html).                                                                     |

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

| [registerMode](#registerMode)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:registerMode(mode, enterModeShortcut, shortcuts) -> table of state transition events, table of registered shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers a new custom mode and its keyboard shortcuts.                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the new mode to be registered</li><li>`enterModeShortcut` - The shortcut that will be available in normal mode to enter the new custom mode</li></ul> |

| [registerModeShortcuts](#registerModeShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:registerModeShortcuts(mode, shortcuts) -> table of registered shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers a set of shortcuts for a mode that is already registered.                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the mode</li><li>`shortcuts` - A list of shortcuts</li></ul> |
| **Returns**                                 | <ul><li> The total list of shortcuts registered for the given mode</li></ul>          |

| [registerModeTransition](#registerModeTransition)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:registerModeTransition(fromMode, toMode, transitionModeShortcut[, transitionName]) -> table of state transition events, table of registered shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Allows a transition between two modes and registers the shortcut in normal mode to transition to the target mode                                                                     |
| **Parameters**                              | <ul><li>`fromMode` - The name of the starting mode that will have the transition shortcut assigned to</li><li>`toMode` - The name of the target mode that will be transitioned to from the `fromMode` mode</li><li>`transitionModeShortcut` - The shortcut to be assigned to the `fromMode` to transition to the `toMode`</li><li>`transitionName` - An optional name for the transition method to be made available on [`Ki.state`](Ki.html#state). Defaults to "enter?Mode", ? being the capitalized mode name.</li></ul> |

| [remapShortcuts](#remapShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:remapShortcuts(shortcuts) -> table of categorized shortcut mappings`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Remaps a categorized set of shortcuts, each matching the argument list for [hotkey bindings](https://www.hammerspoon.org/docs/hs.hotkey.html#bind) in Hammerspoon: modifier keys list and key name (i.e. `{ {"cmd", "shift"}, "s" }`).                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - A set of shortcuts categorized by either the shortcut category and description (used in the cheatsheet) or by mode and entity name</li></ul> |

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

