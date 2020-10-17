----------------------------------------------------------------------------------------------------
-- Preview application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local close = Application:createMenuItemAction("Close Window", { focusBefore = true })
local find = Application:createMenuItemAction({ "Find", "Find..." }, { focusAfter = true })
local open = Application:createMenuItemAction("Open...", { focusAfter = true })
local openRecent = Application:createChooseMenuItemAction({ "File", "Open Recent" }, {
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
