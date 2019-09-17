local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    close = Application.createMenuItemEvent("Close Window", { focusBefore = true }),
    find = Application.createMenuItemEvent({ "Find", "Find..." }, { focusAfter = true }),
    open = Application.createMenuItemEvent("Open...", { focusAfter = true }),
    openRecent = Application.createMenuItemSelectionEvent({ "File", "Open Recent" }, {
        focusAfter = true,
    }),
}

local shortcuts = {
    { nil, "o", actions.open, { "File", "Open..." } },
    { nil, "w", actions.close, { "File", "Close Window" } },
    { { "cmd" }, "f", actions.find, { "Edit", "Find..." } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
}

return Application:new("Preview", shortcuts), shortcuts, actions
