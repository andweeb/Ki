----------------------------------------------------------------------------------------------------
-- TextEdit application
--
local Application = spoon.Ki.Application
local TextEdit = Application:new("TextEdit")

-- Initialize menu item events
TextEdit.newDocument = Application.createMenuItemEvent("New", { focusAfter = true })
TextEdit.saveDocument = Application.createMenuItemEvent("Save", { focusAfter = true })
TextEdit.openDocument = Application.createMenuItemEvent("Open...", { focusAfter = true })
TextEdit.openRecent = Application.createMenuItemChooserEvent({ "File", "Open Recent" }, { focusAfter = true })
TextEdit.printDocument = Application.createMenuItemEvent("Print...", { focusBefore = true })
TextEdit.closeDocument = Application.createMenuItemEvent("Close", { focusBefore = true })
TextEdit.duplicateDocument = Application.createMenuItemEvent("Duplicate", { focusAfter = true })

TextEdit:registerShortcuts({
    { nil, "n", TextEdit.newDocument, { "File", "New Document" } },
    { nil, "o", TextEdit.openDocument, { "File", "Open Document" } },
    { nil, "p", TextEdit.printDocument, { "File", "Print Document" } },
    { nil, "s", TextEdit.saveDocument, { "File", "Save Document" } },
    { nil, "w", TextEdit.closeDocument, { "File", "Close Document" } },
    { { "shift" }, "o", TextEdit.openRecent, { "File", "Open Recent" } },
    { { "shift" }, "s", TextEdit.duplicateDocument, { "File", "Duplicate Document" } },
})

return TextEdit
