----------------------------------------------------------------------------------------------------
-- Preview application
--
local Application = spoon.Ki.Application
local Preview = Application:new("Preview")

Preview.close = Application.createMenuItemEvent("Close Window", { focusBefore = true })
Preview.find = Application.createMenuItemEvent({ "Find", "Find..." }, { focusAfter = true })
Preview.open = Application.createMenuItemEvent("Open...", { focusAfter = true })
Preview.openRecent = Application.createMenuItemSelectionEvent({ "File", "Open Recent" }, {
    focusAfter = true,
})

Preview:registerShortcuts({
    { nil, "o", Preview.open, { "File", "Open..." } },
    { nil, "w", Preview.close, { "File", "Close Window" } },
    { { "cmd" }, "f", Preview.find, { "Edit", "Find..." } },
    { { "shift" }, "o", Preview.openRecent, { "File", "Open Recent" } },
})

return Preview
