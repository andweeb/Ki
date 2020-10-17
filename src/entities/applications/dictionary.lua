----------------------------------------------------------------------------------------------------
-- Dictionary application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newWindow = Application:createMenuItemAction("New Window", { focusAfter = true })
local newTab = Application:createMenuItemAction("New Tab", { focusAfter = true })
local search = Application:createMenuItemAction("Search For a New Word...", { focusAfter = true })
local close = Application:createMenuItemAction({ "Close Tab", "Close" }, {
    isToggleable = true,
    focusBefore = true,
})

return Application {
    name = "Dictionary",
    shortcuts = {
        { nil, "n", newWindow, "New Window" },
        { nil, "t", newTab, "New Tab" },
        { nil, "w", close, "Close Tab or Window" },
        { { "shift" }, "f", search, "Search For a New Word..." },
    },
}
