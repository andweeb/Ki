local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Calendar = Entity:subclass("Calendar")

function Calendar:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "l", function(app) app:selectMenuItem("Find") end, { "Edit", "Find" } },
        { nil, "n", function(app) app:selectMenuItem("New Event") end, { "File", "New Event" } },
        { { "shift" }, "n", function(app) app:selectMenuItem("New Calendar") end, { "File", "New Calendar" } },
        { { "shift" }, "s", function(app) app:selectMenuItem("New Calendar Subscription...") end, { "File", "New Calendar Subscription..." } },
        { { "cmd" }, "f", function(app) app:selectMenuItem("Find") end, { "Edit", "Find" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Calendar", shortcuts)
end

return Calendar
