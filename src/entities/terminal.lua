local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Application = dofile(spoonPath.."/application.lua")
local actions = {
    find = Application.createMenuItemEvent("Find...", { focusBefore = true }),
    newWindow = Application.createMenuItemEvent("New Window with Profile .+$", {
        focusBefore = true,
        isRegex = true,
    }),
    newTab = Application.createMenuItemEvent("New Tab with Profile .+$", {
        focusBefore = true,
        isRegex = true,
    }),
    close = Application.createMenuItemEvent({ "Close Tab", "Close Window" }, {
        isToggleable = true,
        focusBefore = true,
    }),
}

local shortcuts = {
    { nil, "n", actions.newWindow, { "Shell", "New Window" } },
    { nil, "t", actions.newTab, { "Shell", "New Tab" } },
    { nil, "w", actions.close, { "Shell", "Close Tab or Window" } },
    { { "cmd" }, "f", actions.find, { "Edit", "Find..." } },
}

return Application:new("Terminal", shortcuts), shortcuts, actions
