----------------------------------------------------------------------------------------------------
-- Dictionary application
--
local Application = spoon.Ki.Application
local Dictionary = Application:new("Dictionary")

Dictionary.newWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
Dictionary.newTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
Dictionary.search = Application.createMenuItemEvent("Search For a New Word...", { focusAfter = true })
Dictionary.close = Application.createMenuItemEvent({ "Close Tab", "Close" }, {
    isToggleable = true,
    focusBefore = true,
})

Dictionary:registerShortcuts({
    { nil, "n", Dictionary.newWindow, { "File", "New Window" } },
    { nil, "t", Dictionary.newTab, { "File", "New Tab" } },
    { nil, "w", Dictionary.close, { "File", "Close Tab or Window" } },
    { { "cmd" }, "f", Dictionary.search, { "Edit", "Search For a New Word..." } },
})

return Dictionary
