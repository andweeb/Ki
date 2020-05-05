# [docs](index.md) » ApplicationWatcher
---

A module that wraps [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) to track application states


## API Overview
* Constants - Useful values which cannot be changed
 * [actions](#actions)
 * [states](#states)
 * [statusTypes](#statusTypes)
* Methods - API calls which can only be made on an object returned by a constructor
 * [registerEventCallback](#registerEventCallback)
 * [start](#start)

## API Documentation

### Constants

| [actions](#actions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ApplicationWatcher.actions`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A table of actions awaiting invocation keyed by application name. Each value will be a table of callbacks keyed by [status type](#statusTypes).                                                                     |

| [states](#states)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ApplicationWatcher.states`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A table of status information keyed by application name, with each status information table containing the following keys:                                                                     |

| [statusTypes](#statusTypes)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ApplicationWatcher.statusTypes`                                                                    |
| **Type**                                    | Constant                                                                     |
| **Description**                             | A table containing the [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) status type constants defined [here](http://www.hammerspoon.org/docs/hs.application.watcher.html#activated).                                                                     |

### Methods

| [registerEventCallback](#registerEventCallback)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ApplicationWatcher:registerEventCallback(name, event, callback)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers a callback to be invoked upon some event for a particular application                                                                     |
| **Parameters**                              | <ul><li>`name` - A string containing the name of the application</li><li>`event` - An event type (one of [`statusTypes`](#statusTypes))</li><li>`callback` - The callback to be invoked upon the event for the application</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

| [start](#start)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `ApplicationWatcher:start()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Starts the application watcher                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> The started [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) instance</li></ul>          |

