----------------------------------------------------------------------------------------------------
-- Terminal application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application:createMenuItemAction("Find...", { focusBefore = true })
local newWindow = Application:createMenuItemAction("New Window with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
local newTab = Application:createMenuItemAction("New Tab with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
local close = Application:createMenuItemAction({ "Close Tab", "Close Window" }, {
    isToggleable = true,
    focusBefore = true,
})

return Application {
    name = "Terminal",
    shortcuts = {
        { nil, "n", newWindow, "New Window" },
        { nil, "t", newTab, "New Tab" },
        { nil, "w", close, "Close Tab or Window" },
        { { "shift" }, "f", find, "Find..." },
    },
}
