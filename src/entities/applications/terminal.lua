----------------------------------------------------------------------------------------------------
-- Terminal application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application.createMenuItemEvent("Find...", { focusBefore = true })
local newWindow = Application.createMenuItemEvent("New Window with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
local newTab = Application.createMenuItemEvent("New Tab with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
local close = Application.createMenuItemEvent({ "Close Tab", "Close Window" }, {
    isToggleable = true,
    focusBefore = true,
})

return Application {
    name = "Terminal",
    shortcuts = {
        { nil, "n", newWindow, { "Shell", "New Window" } },
        { nil, "t", newTab, { "Shell", "New Tab" } },
        { nil, "w", close, { "Shell", "Close Tab or Window" } },
        { { "shift" }, "f", find, { "Edit", "Find..." } },
    },
}
