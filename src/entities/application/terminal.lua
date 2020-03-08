----------------------------------------------------------------------------------------------------
-- Terminal application
--
local Application = spoon.Ki.Application
local Terminal = Application:new("Terminal")

Terminal.find = Application.createMenuItemEvent("Find...", { focusBefore = true })
Terminal.newWindow = Application.createMenuItemEvent("New Window with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
Terminal.newTab = Application.createMenuItemEvent("New Tab with Profile .+$", {
    focusBefore = true,
    isRegex = true,
})
Terminal.close = Application.createMenuItemEvent({ "Close Tab", "Close Window" }, {
    isToggleable = true,
    focusBefore = true,
})

Terminal:registerShortcuts({
    { nil, "n", Terminal.newWindow, { "Shell", "New Window" } },
    { nil, "t", Terminal.newTab, { "Shell", "New Tab" } },
    { nil, "w", Terminal.close, { "Shell", "Close Tab or Window" } },
    { { "cmd" }, "f", Terminal.find, { "Edit", "Find..." } },
})

return Terminal
