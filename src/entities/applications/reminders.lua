----------------------------------------------------------------------------------------------------
-- Reminders application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application:createMenuItemAction("Find", { focusBefore = true })
local newReminder = Application:createMenuItemAction("New Reminder", { focusBefore = true })
local newReminderList = Application:createMenuItemAction("New List", { focusBefore = true })
local goToToday = Application:createMenuItemAction("Go to Today", { focusBefore = true })

return Application {
    name = "Reminders",
    shortcuts = {
        { nil, "n", newReminder, "New Reminder" },
        { nil, "t", goToToday, "Go to Today" },
        { { "shift" }, "f", find, "Find" },
        { { "shift" }, "n", newReminderList, "New List" },
    },
}
