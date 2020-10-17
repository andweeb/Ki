----------------------------------------------------------------------------------------------------
-- TextEdit application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newDocument = Application:createMenuItemAction("New", { focusAfter = true })
local saveDocument = Application:createMenuItemAction("Save", { focusAfter = true })
local openDocument = Application:createMenuItemAction("Open...", { focusAfter = true })
local openRecent = Application:createChooseMenuItemAction({ "File", "Open Recent" }, { focusAfter = true })
local printDocument = Application:createMenuItemAction("Print...", { focusBefore = true })
local closeDocument = Application:createMenuItemAction("Close", { focusBefore = true })
local duplicateDocument = Application:createMenuItemAction("Duplicate", { focusAfter = true })

return Application {
    name = "TextEdit",
    shortcuts = {
        { nil, "n", newDocument, "New Document" },
        { nil, "o", openDocument, "Open Document" },
        { nil, "p", printDocument, "Print Document" },
        { nil, "s", saveDocument, "Save Document" },
        { nil, "w", closeDocument, "Close Document" },
        { { "shift" }, "o", openRecent, "Open Recent" },
        { { "shift" }, "s", duplicateDocument, "Duplicate Document" },
    },
}
