----------------------------------------------------------------------------------------------------
-- Calendar application
--
local Application = spoon.Ki.Application
local Calendar = Application:new("Calendar")

-- Initialize menu item events
Calendar.find = Application.createMenuItemEvent("Find", { focusAfter = true })
Calendar.newEvent = Application.createMenuItemEvent("New Event", { focusAfter = true })
Calendar.newCalendar = Application.createMenuItemEvent("New Calendar", { focusAfter = true })
Calendar.newCalendarSubscription = Application.createMenuItemEvent("New Calendar Subscription...", {
    focusAfter = true,
})

Calendar:registerShortcuts({
    { nil, "l", Calendar.find, { "Edit", "Find" } },
    { nil, "n", Calendar.newEvent, { "File", "New Event" } },
    { { "shift" }, "f", Calendar.find, { "Edit", "Find" } },
    { { "shift" }, "n", Calendar.newCalendar, { "File", "New Calendar" } },
    { { "shift" }, "s", Calendar.newCalendarSubscription, { "File", "New Calendar Subscription..." } },
})

return Calendar
