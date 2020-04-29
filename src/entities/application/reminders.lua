----------------------------------------------------------------------------------------------------
-- Reminders application
--
local Application = spoon.Ki.Application
local Reminders = Application:new("Reminders")

-- Initialize menu item events
Reminders.find = Application.createMenuItemEvent("Find", { focusBefore = true })
Reminders.newReminder = Application.createMenuItemEvent("New Reminder", { focusBefore = true })
Reminders.newReminderList = Application.createMenuItemEvent("New List", { focusBefore = true })
Reminders.goToToday = Application.createMenuItemEvent("Go to Today", { focusBefore = true })

Reminders:registerShortcuts({
    { nil, "n", Reminders.newReminder, { "File", "New Reminder" } },
    { nil, "t", Reminders.goToToday, { "View", "Go to Today" } },
    { { "cmd" }, "f", Reminders.find, { "Edit", "Find" } },
    { { "shift" }, "n", Reminders.newReminderList, { "File", "New List" } },
})

return Reminders
