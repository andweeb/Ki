local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local SystemPreferences = Entity:subclass("SystemPreferences")

function SystemPreferences.search(app)
    SystemPreferences.focus(app)
    app:selectMenuItem("Search")
    return true
end

function SystemPreferences.showAllPreferences(app)
    SystemPreferences.focus(app)
    app:selectMenuItem("Show All Preferences")
    return true
end

function SystemPreferences:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "l", self.showAllPreferences, { "View", "Show All Preferences" } },
        { { "cmd" }, "f", self.search, { "View", "Search" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "System Preferences", shortcuts)
end

return SystemPreferences
