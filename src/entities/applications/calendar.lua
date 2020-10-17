----------------------------------------------------------------------------------------------------
-- Calendar application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application:createMenuItemAction("Find", { focusAfter = true })
local newEvent = Application:createMenuItemAction("New Event", { focusAfter = true })
local newCalendar = Application:createMenuItemAction("New Calendar", { focusAfter = true })
local newCalendarSubscription = Application:createMenuItemAction("New Calendar Subscription...", {
    focusAfter = true,
})

return Application {
    name = "Calendar",
    shortcuts = {
        { nil, "l", find, "Find" },
        { nil, "n", newEvent, "New Event" },
        { { "shift" }, "f", find, "Find" },
        { { "shift" }, "n", newCalendar, "New Calendar" },
        { { "shift" }, "s", newCalendarSubscription, "New Calendar Subscription..." },
    },
}
