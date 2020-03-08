# [docs](index.md) » Ki
---

**Expressive modal macOS automation, inspired by vi**

Ki uses some particular terminology in its API and documentation:
* **event** - a step in a desktop workflow, consisting of the event handler and assigned shortcut keybinding. The table structure matches the argument list for hotkey bindings in Hammerspoon: modifier keys, key name, and event handler. For example, the following events open applications on keydown events on `s` and `⇧⌘s`:
```lua
local openSafari = function() hs.application.launchOrFocus("Safari") end
local openSpotify = function() hs.application.launchOrFocus("Spotify") end
local shortcuts = {
    { nil, "s", openSafari, { "Safari", "Activate/Focus" } },
    { { "cmd", "shift" }, "s", openSpotify, { "Spotify", "Activate/Focus" } },
}
```
An [`Entity`](#Entity) instance can be also used as an event handler:
```lua
local shortcuts = {
    { nil, "s", Ki.createApplication("Safari"), { "Safari", "Activate/Focus" } },
    { { "cmd", "shift" }, "e", Ki.createApplication("Spotify"), { "Spotify", "Activate/Focus" } },
}
```
The boolean return value of the event handler or an entity's `dispatchAction` function indicates whether to automatically exit back to `desktop` mode after the action has completed.

* **state event** - a unidirectional link between two states in the [finite state machine](https://github.com/unindented/lua-fsm#usage) (structured differently from workflow/transition events). The state events below allow the user to transition from `desktop` mode to `normal` mode to `entity` mode and back to `desktop` mode:
 ```
 local stateEvents = {
     { name = "enterNormalMode", from = "desktop", to = "normal" },
     { name = "enterEntityMode", from = "normal", to = "entity" },
     { name = "exitMode", from = "entity", to = "desktop" },
 }
 ```

* **transition event** - an event that represents a mode transition. Its event handler invokes some state change through the finite state machine. Assuming state events have been initialized correctly, the following transition events invoke methods on `Ki.state` to allow the user to enter `entity` and `action` mode:
 ```
 { {"cmd"}, "e", function() Ki.state:enterEntityMode() end },
 { {"cmd"}, "a", function() Ki.state:enterActionMode() end },
 ```

* **workflow** - a series of transition and workflow events that execute some desktop task, cycling from `desktop` mode back to `desktop` mode

* **workflow event** - an event that carries out the automative aspect in a workflow; basically an event that's not a transition or state event

## API Overview
* Variables - Configurable values
 * [Application](#Application)
 * [defaultEntities](#defaultEntities)
 * [defaultTransitionEvents](#defaultTransitionEvents)
 * [defaultUrlEntities](#defaultUrlEntities)
 * [defaultWorkflowEvents](#defaultWorkflowEvents)
 * [Entity](#Entity)
 * [File](#File)
 * [SmartFolder](#SmartFolder)
 * [state](#state)
 * [stateEvents](#stateEvents)
 * [statusDisplay](#statusDisplay)
 * [transitionEvents](#transitionEvents)
 * [URL](#URL)
 * [workflowEvents](#workflowEvents)
* Methods - API calls which can only be made on an object returned by a constructor
 * [start](#start)
 * [stop](#stop)
 * [useDefaultConfig](#useDefaultConfig)

## API Documentation

### Variables

| [Application](#Application)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.Application`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that subclasses [Entity](Entity.html) to represent some automatable desktop application. Class methods and properties are documented [here](Application.html).                                                                     |

| [defaultEntities](#defaultEntities)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultEntities`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default automatable desktop entity instances in Ki.                                                                     |

| [defaultTransitionEvents](#defaultTransitionEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultTransitionEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default transition events for all default modes in Ki.                                                                     |

| [defaultUrlEntities](#defaultUrlEntities)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultUrlEntities`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default automatable URL entity instances in Ki.                                                                     |

| [defaultWorkflowEvents](#defaultWorkflowEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultWorkflowEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default workflow events for all default modes in Ki.                                                                     |

| [Entity](#Entity)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.Entity`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some generic automatable desktop entity. Class methods and properties are documented [here](Entity.html).                                                                     |

| [File](#File)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.File`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some file or directory at an existing file path. Class methods and properties are documented [here](File.html).                                                                     |

| [SmartFolder](#SmartFolder)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.SmartFolder`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some [smart folder](https://support.apple.com/kb/PH25589) at an existing file path. Class methods and properties are documented [here](SmartFolder.html).                                                                     |

| [state](#state)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.state`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | The internal [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki.                                                                     |

| [stateEvents](#stateEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.stateEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the [state events](https://github.com/unindented/lua-fsm#usage) for the finite state machine set to `Ki.state`. Custom state events can be set to `Ki.stateEvents` before calling `Ki.start()` to set up the FSM with custom transition events.                                                                     |

| [statusDisplay](#statusDisplay)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.statusDisplay`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table that defines the behavior for displaying the status of mode transitions. The `show` function should clear out any previous display and show the current transitioned mode. The following methods should be available on the object:                                                                     |

| [transitionEvents](#transitionEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.transitionEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the definitions of transition events.                                                                     |

| [URL](#URL)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.URL`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A [middleclass](https://github.com/kikito/middleclass/wiki) class that represents some url. Class methods and properties are documented [here](URL.html).                                                                     |

| [workflowEvents](#workflowEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.workflowEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing lists of custom workflow events keyed by mode name. The following example creates two entity and url events:                                                                     |

### Methods

| [start](#start)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:start() -> hs.eventtap`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the status display, creates all transition and workflow events, and starts the input event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object</li></ul>          |

| [stop](#stop)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:stop() -> hs.eventtap`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Stops the input event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> An [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) object</li></ul>          |

| [useDefaultConfig](#useDefaultConfig)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:useDefaultConfig([options])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Loads the default config                                                                     |
| **Parameters**                              | <ul><li>`options` - A table containing options that configures which default configs to load</li><li>  `include` - A list of entity filenames to load, in which all unspecified entities will not be loaded</li><li>  `exclude` - A list of entity filenames to exclude from loading, in which all unspecified filenames will be loaded</li></ul> |

