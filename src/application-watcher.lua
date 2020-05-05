--- === ApplicationWatcher ===
---
--- A module that wraps [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) to track application states
---

local ApplicationWatcher = {}

--- ApplicationWatcher.actions
--- Constant
--- A table of actions awaiting invocation keyed by application name. Each value will be a table of callbacks keyed by [status type](#statusTypes).
ApplicationWatcher.actions = {}

--- ApplicationWatcher.states
--- Constant
--- A table of status information keyed by application name, with each status information table containing the following keys:
--- * `status` - The application status, one of the [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) state constants documented [here](http://www.hammerspoon.org/docs/hs.application.watcher.html#activated)
--- * `app` - An [`hs.application`](https://www.hammerspoon.org/docs/hs.application.html) object representing the application, or nil if the application couldn't be found
ApplicationWatcher.states = {}

--- ApplicationWatcher.statusTypes
--- Constant
--- A table containing the [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) status type constants defined [here](http://www.hammerspoon.org/docs/hs.application.watcher.html#activated).
ApplicationWatcher.statusTypes = {
    activated = hs.application.watcher.activated,
    deactivated = hs.application.watcher.deactivated,
    hidden = hs.application.watcher.hidden,
    launched = hs.application.watcher.launched,
    launching = hs.application.watcher.launching,
    terminated = hs.application.watcher.terminated,
    unhidden = hs.application.watcher.unhidden,
}

-- Sets the state of the application with the triggered event on `ApplicationWatcher.states`.
function ApplicationWatcher:handleEvent(name, event, app)
    -- Store the new application state
    self.states[name] = { status = event, app = app }

    -- Invoke and remove the event callback if it was registered for the event
    if self.actions[name] and self.actions[name][event] then
        local callback = self.actions[name][event]

        -- Invoke the registered callback
        if event == self.statusTypes.launched then
            hs.timer.doAfter(1, function() callback(app) end)
        else
            callback(app)
        end

        -- Unset callback
        self.actions[name][event] = nil
    end
end

-- The underlying `hs.application.watcher` instance
ApplicationWatcher.watcher = hs.application.watcher.new(function(...)
    ApplicationWatcher:handleEvent(...)
end)

--- ApplicationWatcher:registerEventCallback(name, event, callback)
--- Method
--- Registers a callback to be invoked upon some event for a particular application
---
--- Parameters:
---  * `name` - A string containing the name of the application
---  * `event` - An event type (one of [`statusTypes`](#statusTypes))
---  * `callback` - The callback to be invoked upon the event for the application
---
--- Returns:
---   * None
function ApplicationWatcher:registerEventCallback(name, event, callback)
    self.actions[name] = self.actions[name] or {}
    self.actions[name][event] = callback
end

--- ApplicationWatcher:start()
--- Method
--- Starts the application watcher
---
--- Parameters:
---  * None
---
--- Returns:
---   * The started [`hs.application.watcher`](http://www.hammerspoon.org/docs/hs.application.watcher.html) instance
function ApplicationWatcher:start()
    return self.watcher:start()
end

return ApplicationWatcher
