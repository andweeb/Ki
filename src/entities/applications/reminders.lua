----------------------------------------------------------------------------------------------------
-- Reminders application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application.createMenuItemEvent("Find", { focusBefore = true })
local newReminder = Application.createMenuItemEvent("New Reminder", { focusBefore = true })
local newReminderList = Application.createMenuItemEvent("New List", { focusBefore = true })
local goToToday = Application.createMenuItemEvent("Go to Today", { focusBefore = true })

return Application {
    name = "Reminders",
    shortcuts = {
        { nil, "n", newReminder, { "File", "New Reminder" } },
        { nil, "t", goToToday, { "View", "Go to Today" } },
        { { "shift" }, "f", find, { "Edit", "Find" } },
        { { "shift" }, "n", newReminderList, { "File", "New List" } },
    },
}
