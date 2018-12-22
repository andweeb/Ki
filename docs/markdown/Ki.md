# [docs](index.md) » Ki
---

Modal macOS automation inspired by the vi text editor

Ki uses some particular terminology in its API and documentation:
* **event** - a step in a desktop workflow, consisting of the event handler and assigned shortcut keybinding. The table structure matches the argument list for hotkey bindings in Hammerspoon: modifier keys, key name, and event handler. For example, the following events open applications on keydown events on `s` and `⇧⌘s`:
```lua
local openSafari = function() hs.application.launchOrFocus("Safari") end
local openSpotify = function() hs.application.launchOrFocus("Spotify") end
local shortcuts = {
    { nil, "s", openSafari, { "Safari", "Activate/Focus" } },
    { { "shift" }, "s", openSpotify, { "Spotify", "Activate/Focus" } },
}
```
An `Entity` instance can be also used as an event handler:
```lua
local shortcuts = {
    { nil, "e", Ki.createApplication("Microsoft Excel"), { "Microsoft Excel", "Activate/Focus" } },
}
```

* **state event** - a unidirectional link between two states in the [finite state machine](https://github.com/unindented/lua-fsm#usage) (structured differently from workflow/transition events). The state events below allow the user to transition from `desktop` mode to `normal` mode to `entity` mode and exit back to `desktop` mode:
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

* **workflow event** - an event that carries out the automative aspect in a workflow

## API Overview
* Variables - Configurable values
 * [defaultEntities](#defaultEntities)
 * [defaultEvents](#defaultEvents)
 * [state](#state)
 * [stateEvents](#stateEvents)
 * [statusDisplay](#statusDisplay)
 * [transitions](#transitions)
 * [workflows](#workflows)
* Methods - API calls which can only be made on an object returned by a constructor
 * [createApplication](#createApplication)
 * [createEntity](#createEntity)
 * [start](#start)
 * [stop](#stop)

## API Documentation

### Variables

| [defaultEntities](#defaultEntities)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultEntities`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default automatable desktop entity instances in Ki.                                                                     |

| [defaultEvents](#defaultEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.defaultEvents`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the default events for all default modes in Ki.                                                                     |

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

| [transitions](#transitions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.transitions`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the definitions of transition events.                                                                     |

| [workflows](#workflows)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.workflows`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing lists of workflows keyed by mode name. The following example creates two entity and url events:                                                                     |

### Methods

| [createApplication](#createApplication)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.createApplication([subclassName]) -> base Application class[, subclassed Application class]`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns both the base and (optionally) subclassed [application class](Application.html) for creating custom application entity subclasses or instances                                                                     |
| **Parameters**                              | <ul><li>`subclassName` - optional name to subclass the `Application` class</li></ul> |
| **Returns**                                 | <ul><li> The base `Application` class</li><li> An `Application` subclass or nil if `subclassName` is nil</li></ul>          |

| [createEntity](#createEntity)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.createEntity([subclassName]) -> base Entity class[, subclassed Entity class]`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns both the base and (optionally) subclassed [entity class](Entity.html) for creating custom entity subclasses or instances                                                                     |
| **Parameters**                              | <ul><li>subclassName - an optional name to return a subclassed entity</li></ul> |
| **Returns**                                 | <ul><li> The base `Entity` class</li><li> An `Entity` subclass or nil if `subclassName` is nil</li></ul>          |

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

