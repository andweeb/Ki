# [docs](index.md) » Entity
---

Entity class that represents some abstract automatable desktop entity


## API Overview
* Variables - Configurable values
 * [behaviors](#behaviors)
 * [chooser](#chooser)
 * [chooserShortcuts](#chooserShortcuts)
* Methods - API calls which can only be made on an object returned by a constructor
 * [dispatchAction](#dispatchAction)
 * [getChooserItems](#getChooserItems)
 * [getEventHandler](#getEventHandler)
 * [initialize](#initialize)
 * [loadChooserRowImages](#loadChooserRowImages)
 * [notifyError](#notifyError)
 * [registerChooserShortcuts](#registerChooserShortcuts)
 * [registerShortcuts](#registerShortcuts)
 * [renderScriptTemplate](#renderScriptTemplate)
 * [showActions](#showActions)
 * [showChooser](#showChooser)
 * [triggerAfterConfirmation](#triggerAfterConfirmation)

## API Documentation

### Variables

| [behaviors](#behaviors)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.behaviors`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A table keyed by mode name to define (optional) entity behavior contextual to the mode at the time of an event. The table values are functions that take in the following arguments to invoke the event handler in some mode-specific way:                                                                     |

| [chooser](#chooser)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.chooser`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | The chooser [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) instance or `nil` if not active.                                                                     |

| [chooserShortcuts](#chooserShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.chooserShortcuts`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | A list of shortcuts that can be used when the chooser is visible. The following shortcuts are available by default:                                                                     |

### Methods

| [dispatchAction](#dispatchAction)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:dispatchAction(mode, shortcut) -> boolean`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Dispatch an action from a shortcut within the context of the given mode                                                                     |
| **Parameters**                              | <ul><li>`mode` - The name of the current mode</li><li>`shortcut` - A shortcut object containing the keybindings and event handler for the entity</li><li>`workflow` - The list of events that compose the current workflow</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [getChooserItems](#getChooserItems)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getChooserItems() -> table of choices or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns a list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display in the chooser. Entities intended to be used with select mode must implement this method to correctly display items in the chooser.                                                                     |
| **Returns**                                 | <ul><li> `choices` - A list of choices or `nil`</li></ul>          |

| [getEventHandler](#getEventHandler)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:getEventHandler(shortcuts, flags, keyName) -> function or nil`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Returns the event handler within the provided shortcuts with the given shortcut keybindings, or nil if not found                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcut objects</li><li>`flags` - A table containing the keyboard modifiers in the keyboard event (from `hs.eventtap.event:getFlags()`)</li><li>`keyName` - A string containing the name of a keyboard key (in `hs.keycodes.map`)</li></ul> |
| **Returns**                                 | <ul><li>A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul>          |

| [initialize](#initialize)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:initialize(name, shortcuts, autoExitMode)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Initializes a new entity instance with its name and shortcuts. By default, a `cheatsheet` object will be initialized on the entity object with metadata in the provided shortcut keybindings, and dispatched actions will automatically exit the current mode by default unless the `autoExitMode` parameter is explicitly set to `false`.                                                                     |
| **Parameters**                              | <ul><li>`name` - The entity name</li><li>`shortcuts` - The list of shortcuts containing keybindings and actions for the entity</li><li>`autoExitMode` - A boolean denoting to whether enable or disable automatic mode exit after the action has been dispatched</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [loadChooserRowImages](#loadChooserRowImages)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:loadChooserRowImages(choices[, reload])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | For a given set of choices, asynchronously loads images from an `imageURL` key for each choice object and refreshes the callback for a chooser with a choices callback.                                                                     |
| **Parameters**                              | <ul><li>`choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects</li><li>`reload` - An optional boolean value to pass to [`hs.chooser:refreshChoicesCallback`](http://www.hammerspoon.org/docs/hs.chooser.html#refreshChoicesCallback). Defaults to `true`.</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [notifyError](#notifyError)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.notifyError(message, details)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Displays error details in a notification and logs to the Hammerspoon console                                                                     |
| **Parameters**                              | <ul><li>`message` - The main notification message</li><li>`details` - The textual body of the notification containing details of the error</li></ul> |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [registerChooserShortcuts](#registerChooserShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:registerChooserShortcuts(shortcuts, override) -> table of registered shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers a list of chooser shortcuts with the option of merging with the existing [default](#chooserShortcuts) or previously initialized chooser shortcuts.                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcut objects. Shortcut event handlers will be invoked with the [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) instance:</li><li>   ```</li><li>   { { "ctrl" }, "j", function(chooser) chooser:selectedRow(chooser:selectedRow() + 1) end },</li><li>   { { "ctrl" }, "k", function(chooser) chooser:selectedRow(chooser:selectedRow() - 1) end },</li><li>   ```</li><li>`override` - A boolean denoting to whether to override the existing chooser shortcuts</li></ul> |
| **Returns**                                 | <ul><li> `shortcuts` - Returns the list of registered chooser shortcuts</li></ul>          |

| [registerShortcuts](#registerShortcuts)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:registerShortcuts(shortcuts[, override]) -> table of shortcuts`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Registers and updates the entity cheatsheet with a list of shortcuts with the option of merging with the existing default or previously initialized shortcuts.                                                                     |
| **Parameters**                              | <ul><li>`shortcuts` - The list of shortcut objects</li><li>`override` - A boolean denoting to whether to override the existing set of shortcuts</li></ul> |
| **Returns**                                 | <ul><li> `shortcuts` - Returns the list of registered shortcuts</li></ul>          |

| [renderScriptTemplate](#renderScriptTemplate)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.renderScriptTemplate(script[, viewModel]) -> string`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Generates an applescript from templates located in `src/osascripts` with some view model object                                                                     |
| **Parameters**                              | <ul><li>`scriptPath` - The absolute file path to the applescript file or the name of an existing Ki applescript file (in src/osascripts)</li><li>`viewModel` - An optional [lustache](http://olivinelabs.com/lustache/) view model</li></ul> |
| **Returns**                                 | <ul><li>The rendered script string or `nil`</li></ul>          |

| [showActions](#showActions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:showActions()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a chooser populated with actions configured on the entity, which upon selection will trigger the action                                                                     |
| **Returns**                                 | <ul><li>None</li></ul>          |

| [showChooser](#showChooser)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity:showChooser(choices, callback[, options])`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Shows a [chooser](http://www.hammerspoon.org/docs/hs.chooser.html) with a list of choices. The chooser can be closed with Escape <kbd>⎋</kbd>.                                                                     |
| **Parameters**                              | <ul><li>`choices` - A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects to display on the chooser</li><li>`callback` - The callback function invoked when a row is selected</li><li>`options` - A table containing various options to configure the chooser:</li><li>  `placeholderText` - Set the placeholder text</li></ul> |
| **Returns**                                 | <ul><li>The [`hs.chooser`](https://www.hammerspoon.org/docs/hs.chooser.html) object</li></ul>          |

| [triggerAfterConfirmation](#triggerAfterConfirmation)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `Entity.triggerAfterConfirmation(question, details, action)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Opens a dialog block alert for user confirmation before triggering an action                                                                     |
| **Parameters**                              | <ul><li>`question` - Text to display in the block alert as the title</li><li>`details` - Text to display in the block alert as the description</li><li>`action` - The callback function to be invoked after user confirmation</li></ul> |
| **Returns**                                 | <ul><li> None</li></ul>          |

