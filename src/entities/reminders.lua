local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Reminders = Entity:subclass("Reminders")

function Reminders.find(app)
    Reminders.focus(app)
    app:selectMenuItem("Find")
end

function Reminders.newReminder(app)
    Reminders.focus(app)
    app:selectMenuItem("New Reminder")
end

function Reminders.newReminderList(app)
    Reminders.focus(app)
    app:selectMenuItem("New List")
end

function Reminders.goToToday(app)
    Reminders.focus(app)
    app:selectMenuItem("Go to Today")
end

function Reminders:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "n", self.newReminder, { "File", "New Reminder" } },
        { nil, "t", self.goToToday, { "View", "Go to Today" } },
        { { "cmd" }, "f", self.find, { "Edit", "Find" } },
        { { "shift" }, "n", self.newReminderList, { "File", "New List" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Reminders", shortcuts)
end

return Reminders
