local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Application = dofile(spoonPath.."/application.lua")
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
