----------------------------------------------------------------------------------------------------
-- Calendar application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application.createMenuItemEvent("Find", { focusAfter = true })
local newEvent = Application.createMenuItemEvent("New Event", { focusAfter = true })
local newCalendar = Application.createMenuItemEvent("New Calendar", { focusAfter = true })
local newCalendarSubscription = Application.createMenuItemEvent("New Calendar Subscription...", {
    focusAfter = true,
})

return Application {
    name = "Calendar",
    shortcuts = {
        { nil, "l", find, { "Edit", "Find" } },
        { nil, "n", newEvent, { "File", "New Event" } },
        { { "shift" }, "f", find, { "Edit", "Find" } },
        { { "shift" }, "n", newCalendar, { "File", "New Calendar" } },
        { { "shift" }, "s", newCalendarSubscription, { "File", "New Calendar Subscription..." } },
    },
}
