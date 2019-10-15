# [docs](index.md) » Defaults
---

Definitions of default events and entities


## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [create](#create)
 * [createBrightnessEvents](#createBrightnessEvents)
 * [createEntityEvents](#createEntityEvents)
 * [createFileEvents](#createFileEvents)
 * [createNormalEvents](#createNormalEvents)
 * [createUrlEvents](#createUrlEvents)
 * [createVolumeEvents](#createVolumeEvents)

## API Documentation

### Methods

| [create](#create)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.create(Ki) -> events, entities`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Creates the default Ki events and entities                                                                     |
| **Parameters**                              | <ul><li>Ki - the Ki object</li></ul> |
| **Returns**                                 | <ul><li> A table containing events for `url`, `select`, `entity`, `volume`, `brightness`, and `normal` modes</li><li> A table containing all default desktop entity objects</li></ul>          |

| [createBrightnessEvents](#createBrightnessEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createBrightnessEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `brightness` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `brightness` workflow events</li></ul>          |

| [createEntityEvents](#createEntityEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createEntityEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `entity` and `select` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `entity` workflow events</li><li>A list of `select` workflow events</li></ul>          |

| [createFileEvents](#createFileEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createFileEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `file` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `file` workflow events</li></ul>          |

| [createNormalEvents](#createNormalEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createNormalEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `normal` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `normal` workflow events</li></ul>          |

| [createUrlEvents](#createUrlEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createUrlEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `url` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `url` workflow events</li><li>A table of `url` entities</li></ul>          |

| [createVolumeEvents](#createVolumeEvents)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Defaults.createVolumeEvents()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Defines the initial set of actions with predefined keybindings for `volume` mode                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li>A list of `volume` workflow events</li></ul>          |

