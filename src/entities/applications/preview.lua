----------------------------------------------------------------------------------------------------
-- Preview application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local close = Application.createMenuItemEvent("Close Window", { focusBefore = true })
local find = Application.createMenuItemEvent({ "Find", "Find..." }, { focusAfter = true })
local open = Application.createMenuItemEvent("Open...", { focusAfter = true })
local openRecent = Application.createMenuItemChooserEvent({ "File", "Open Recent" }, {
    focusAfter = true,
})

return Application {
    name = "Preview",
    shortcuts = {
        { nil, "o", open, "Open..." },
        { nil, "w", close, "Close Window" },
        { { "cmd" }, "f", find, "Find..." },
        { { "shift" }, "o", openRecent, "Open Recent" },
    },
}
