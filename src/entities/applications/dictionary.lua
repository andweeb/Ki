----------------------------------------------------------------------------------------------------
-- Dictionary application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
local newTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
local search = Application.createMenuItemEvent("Search For a New Word...", { focusAfter = true })
local close = Application.createMenuItemEvent({ "Close Tab", "Close" }, {
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
