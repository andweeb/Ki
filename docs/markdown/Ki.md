# [docs](index.md) » Ki
---

Composable, modal macOS automation inspired by the vi

Ki uses some particular terminology in its API and documentation:
* **_event/shortcut_** - a shortcut object containing the event handler and its keybinding. The object structure matches the argument list for hotkeys bindings in Hammerspoon: modifier keys, key name, and event handler function or entity object. For example, the following table represents an keydown event on `⇧⌘m`:
```lua
local shortcuts = {
    { { "shift", "cmd" }, "m", function() print("Pressed the `m` hotkey!") end },
    { { "shift" }, "s", Ki.createEntity("Safari") },
}
```
An entity object that implements a `dispatchAction` can be also used:
```lua
local _, WordApplicationEntity = spoon.Ki.createEntity("Microsoft Word")
local _, ExcelApplicationEntity = spoon.Ki.createEntity("Microsoft Excel")
local shortcuts = {
    { nil, "e", ExcelApplicationEntity },
    { nil, "w", WordApplicationEntity },
}
```

* **_state event_** - a table that defines a unidirectional link between two states in the finite state machine, or transitions between different modes. For example, the `enterEntityMode` state event allows the user to transition from `normal` mode to `entity` mode by calling `Ki.state:entityEntityMode`:
 ```
 local stateEvents = {
     { name = "enterNormalMode", from = "desktop", to = "normal" },
     { name = "enterEntityMode", from = "normal", to = "entity" },
     { name = "exitMode", from = "entity", to = "desktop" },
 }
 ```

* **_transition event_** - a keydown event with a handler function that invokes a state change through the finite state machine. For example, the following transition events invoke fsm callbacks to allow the user to enter `entity` and `action` mode:
 ```
 { {"cmd"}, ";", function() Ki.state:enterEntityMode() end },
 { {"cmd"}, "'", function() Ki.state:enterActionMode() end },
 ```

* **_workflow_** - a list of transition and workflow events that execute a specific task, cycling from `desktop` mode back to `desktop` mode

* **_workflow event_** - a keydown event that's part of some workflow using the Hammerspoon API (i.e., event definitions in `default-workflows.lua`, or any event that is not a transition or state event)

## API Overview
* Variables - Configurable values
 * [state](#state)
 * [states](#states)
 * [statusDisplay](#statusDisplay)
 * [transitions](#transitions)
 * [workflows](#workflows)
* Methods - API calls which can only be made on an object returned by a constructor
 * [createEntity](#createEntity)
 * [start](#start)
 * [stop](#stop)

## API Documentation

### Variables

| [state](#state)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.state`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | The internal [finite state machine](https://github.com/unindented/lua-fsm#usage) used to manage modes in Ki                                                                     |

| [states](#states)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.states`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the [state events](https://github.com/unindented/lua-fsm#usage) for the finite state machine set to `Ki.state`. Custom state events can be set to `Ki.states` before calling `Ki.start()` to set up the FSM with custom transitions events.                                                                     |

| [statusDisplay](#statusDisplay)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.statusDisplay`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table that defines the behavior for displaying the status on mode transitions. The `show` function should clear out any previous display and show the current transitioned mode. The following methods should be available on the object:                                                                     |

| [transitions](#transitions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.transitions`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the definitions of transition events.                                                                     |

| [workflows](#workflows)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.workflows`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing lists of workflow events keyed by mode name. The following example creates two entity and url events:                                                                     |

### Methods

| [createEntity](#createEntity)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.createEntity(subclassName) -> base Entity class[, subclassed Entity class]`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns the both the base and custom subclassed [entity class](Entity.html) for creating custom desktop entities                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> The base `Entity` class</li><li> A subclassed `ExtendedEntity` class if a `subclassName` is specified</li></ul>          |

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

