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
        { nil, "n", newDocument, { "File", "New Document" } },
        { nil, "o", openDocument, { "File", "Open Document" } },
        { nil, "p", printDocument, { "File", "Print Document" } },
        { nil, "s", saveDocument, { "File", "Save Document" } },
        { nil, "w", closeDocument, { "File", "Close Document" } },
        { { "shift" }, "o", openRecent, { "File", "Open Recent" } },
        { { "shift" }, "s", duplicateDocument, { "File", "Duplicate Document" } },
    },
}
