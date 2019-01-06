local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    find = Application.createMenuItemEvent("Find", { focusAfter = true }),
    newEvent = Application.createMenuItemEvent("New Event", { focusAfter = true }),
    newCalendar = Application.createMenuItemEvent("New Calendar", { focusAfter = true }),
    newCalendarSubscription = Application.createMenuItemEvent("New Calendar Subscription...", { focusAfter = true }),
}

local shortcuts = {
    { nil, "l", actions.find, { "Edit", "Find" } },
    { nil, "n", actions.newEvent, { "File", "New Event" } },
    { { "shift" }, "n", actions.newCalendar, { "File", "New Calendar" } },
    { { "shift" }, "s", actions.newCalendarSubscription, { "File", "New Calendar Subscription..." } },
    { { "cmd" }, "f", actions.find, { "Edit", "Find" } },
}

return Application:new("Calendar", shortcuts), shortcuts, actions
