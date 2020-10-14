----------------------------------------------------------------------------------------------------
-- TextEdit application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newDocument = Application.createMenuItemEvent("New", { focusAfter = true })
local saveDocument = Application.createMenuItemEvent("Save", { focusAfter = true })
local openDocument = Application.createMenuItemEvent("Open...", { focusAfter = true })
local openRecent = Application.createMenuItemChooserEvent({ "File", "Open Recent" }, { focusAfter = true })
local printDocument = Application.createMenuItemEvent("Print...", { focusBefore = true })
local closeDocument = Application.createMenuItemEvent("Close", { focusBefore = true })
local duplicateDocument = Application.createMenuItemEvent("Duplicate", { focusAfter = true })

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
