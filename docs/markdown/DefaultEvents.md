# [docs](index.md) » DefaultEvents
---

Definitions of default workflow events for default ki modes


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [init](#init)
 * [initEntityEvents](#initEntityEvents)

## API Documentation

### Methods

| [init](#init)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `DefaultEvents.init()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of default key bindings and creates the workflow event handlers for default modes                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A table containing the default `url`, `entity`, `select`, `volume`, `brightness`, and `normal` workflow events</li></ul>          |

| [initEntityEvents](#initEntityEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `DefaultEvents.initEntityEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `entity` and `select` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `entity` workflow events</li><li>A list of `select` workflow events</li></ul>          |

