local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    find = Application.createMenuItemEvent("Find", { focusBefore = true }),
    newReminder = Application.createMenuItemEvent("New Reminder", { focusBefore = true }),
    newReminderList = Application.createMenuItemEvent("New List", { focusBefore = true }),
    goToToday = Application.createMenuItemEvent("Go to Today", { focusBefore = true }),
}

local shortcuts = {
    { nil, "n", actions.newReminder, { "File", "New Reminder" } },
    { nil, "t", actions.goToToday, { "View", "Go to Today" } },
    { { "cmd" }, "f", actions.find, { "Edit", "Find" } },
    { { "shift" }, "n", actions.newReminderList, { "File", "New List" } },
}

return Application:new("Reminders", shortcuts), shortcuts, actions
