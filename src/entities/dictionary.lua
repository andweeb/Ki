local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Application = dofile(spoonPath.."/application.lua")
local actions = {
    newWindow = Application.createMenuItemEvent("New Window", { focusAfter = true }),
    newTab = Application.createMenuItemEvent("New Tab", { focusAfter = true }),
    search = Application.createMenuItemEvent("Search For a New Word...", { focusAfter = true }),
    close = Application.createMenuItemEvent({ "Close Tab", "Close Window" }, {
        isToggleable = true,
        focusBefore = true,
    }),
}

local shortcuts = {
    { nil, "n", actions.newWindow, { "File", "New Window" } },
    { nil, "t", actions.newTab, { "File", "New Tab" } },
    { nil, "w", actions.close, { "File", "Close Tab or Window" } },
    { { "cmd" }, "f", actions.search, { "Edit", "Search For a New Word..." } },
}

return Application:new("Dictionary", shortcuts), shortcuts, actions
