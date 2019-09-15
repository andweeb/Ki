local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    newDocument = Application.createMenuItemEvent("New", { focusAfter = true }),
    saveDocument = Application.createMenuItemEvent("Save", { focusAfter = true }),
    openDocument = Application.createMenuItemEvent("Open...", { focusAfter = true }),
    openRecent = Application.createMenuItemSelectionEvent({ "File", "Open Recent" }, {
        focusAfter = true,
    }),
    printDocument = Application.createMenuItemEvent("Print...", { focusBefore = true }),
    closeDocument = Application.createMenuItemEvent("Close", { focusBefore = true }),
    duplicateDocument = Application.createMenuItemEvent("Duplicate", { focusAfter = true }),
}

local shortcuts = {
    { nil, "n", actions.newDocument, { "File", "New Document" } },
    { nil, "o", actions.openDocument, { "File", "Open Document" } },
    { nil, "p", actions.printDocument, { "File", "Print Document" } },
    { nil, "s", actions.saveDocument, { "File", "Save Document" } },
    { nil, "w", actions.closeDocument, { "File", "Close Document" } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
    { { "shift" }, "s", actions.duplicateDocument, { "File", "Duplicate Document" } },
}

return Application:new("TextEdit", shortcuts), shortcuts, actions
