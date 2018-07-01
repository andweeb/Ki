# [docs](index.md) » Ki
---

**Enable composable, modal commands to automate your macOS environment**

Here's a list of terms with definitions specific to this extension:
* **_event_** - a keydown event. The event object structure matches the argument list for hotkeys bindings in Hammerspoon: modifier keys, key name, and event handler function. For example, the following table represents an keydown event on `⇧⌘m`:
 ```
 { {"shift", "cmd"}, "m", handleEvent }
 ```

* **_state event_** - a table that defines a unidirectional link between two states in the finite state machine. For example, the `enterEntityMode` state event allows the user to transition from `normal` mode to `entity` mode by calling `ki.state:entityEntityMode`:
 ```
 { name = "enterEntityMode", from = "normal", to = "entity" }
 ```

* **_transition event_** - a keydown event with a handler function that invokes a state change through the finite state machine. For example, the following transition events invoke fsm callbacks to allow the user to enter `entity` and `action` mode:
 ```
 { {"cmd"}, ";", function() ki.state:enterEntityMode() end },
 { {"cmd"}, "'", function() ki.state:enterActionMode() end },
 ```

* **_workflow_** - a list of transition and workflow events that execute a specific task, cycling from `normal` mode back to `normal` mode

* **_workflow event_** - a keydown event that's part of some workflow using the Hammerspoon API (i.e., event definitions in `default-workflows.lua`, or any event that is not a transition or state event)

## API Overview
* Variables - Configurable values
 * [states](#states)
 * [statusDisplay](#statusDisplay)
 * [transitions](#transitions)
 * [workflows](#workflows)
* Methods - API calls which can only be made on an object returned by a constructor
 * [createEntityEventHandler](#createEntityEventHandler)
 * [showSelectionModal](#showSelectionModal)
 * [start](#start)
 * [stop](#stop)

## API Documentation

### Variables

| [states](#states)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.states`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the state events in the finite state machine.                                                                     |

| [statusDisplay](#statusDisplay)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.statusDisplay`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table that defines the behavior for displaying the status on mode transitions. The `show` function should clear out any previous display and show the current transitioned mode with an action if available.                                                                     |

| [transitions](#transitions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.transitions`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing the definitions of transition events. The following `normal` mode transition events are defined to enable the following transitions by default:                                                                     |

| [workflows](#workflows)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki.workflows`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table containing lists of workflow events keyed by mode name. The following example creates two entity and url events:                                                                     |

### Methods

| [createEntityEventHandler](#createEntityEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:createEntityEventHandler(applicationName, eventHandler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | A helper function that invokes an event handler callback with the `hs.application` and keydown event information so event handlers are somewhat less boilerplate-y                                                                     |
| **Parameters**                              | <ul><li>`applicationName` - The application name for use in finding the `hs.application`</li><li>`eventHandler` - A callback function that handles the entity event with the following arguments:</li><li> `app` - The `hs.application` object of the provided application name</li><li> `keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)</li><li> `flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)</li></ul> |

| [showSelectionModal](#showSelectionModal)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:showSelectionModal(choices, selectEventHandler)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Show a selection modal with a list of choices                                                                     |
| **Parameters**                              | <ul><li>`choices` - a table of `hs.chooser` choices</li><li>`selectEventHandler` - the callback invoked when the modal is closed or a selection is made</li></ul> |

| [start](#start)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:start()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the status display, initializes transition and workflow events, and starts the keyboard event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> The `hs.eventtap` object</li></ul>          |

| [stop](#stop)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Ki:stop()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Stops the keyboard event listener                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> The `hs.eventtap` object</li></ul>          |

