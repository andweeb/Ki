local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    search = Application.createMenuItemEvent("Search", { focusBefore = true }),
    showAllPreferences = Application.createMenuItemEvent("Show All Preferences", { focusBefore = true }),
}

local shortcuts = {
    { nil, "l", actions.showAllPreferences, { "View", "Show All Preferences" } },
    { { "cmd" }, "f", actions.search, { "View", "Search" } },
}

return Application:new("System Preferences", shortcuts), shortcuts, actions
