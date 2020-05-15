----------------------------------------------------------------------------------------------------
-- Notes application
--
local Application = spoon.Ki.Application
local Notes = Application:new("Notes")

-- Initialize menu item events
Notes.search = Application.createMenuItemEvent("Search", { focusBefore = true })
Notes.newNote = Application.createMenuItemEvent("New Note", { focusBefore = true })
Notes.newFolder = Application.createMenuItemEvent("New Folder", { focusBefore = true })
Notes.toggleFolderView = Application.createMenuItemEvent({ "Show Folders", "Hide Folders" }, {
    isToggleable = true,
    focusBefore = true,
})
Notes.toggleAttachmentsBrowser = Application.createMenuItemEvent({
    "Show Attachments Browser",
    "Hide Attachments Browser"
}, { isToggleable = true })

-- Implement method to support selection of notes in select mode
function Notes.getSelectionItems()
    local choices = {}
    local isOk, notes, rawTable =
        hs.osascript.applescript(Application.renderScriptTemplate("notes"))

    if not isOk then
        Application.notifyError("Error fetching Notes", rawTable.NSLocalizedFailureReason)

        return {}
    end

    table.sort(notes, function(a, b)
        return a.containerName < b.containerName
    end)

    for _, note in pairs(notes) do
        table.insert(choices, {
            noteId = note.noteId,
            text = note.containerName..": "..note.noteName,
            subText = "Last modified "..note.lastModified,
        })
    end

    return choices
end

-- Action to activate the Notes app or open a particular note
function Notes.focus(app, choice)
    app:activate()

    if choice then
        local isOk, _, rawTable = hs.osascript.applescript([[
            tell application "Notes" to show note id "]]..choice.noteId..[["
        ]])

        if not isOk then
            Application.notifyError("Error selecting the note", rawTable.NSLocalizedFailureReason)
        end
    end
end

Notes:registerShortcuts({
    { nil, nil, Notes.focus, { "Notes", "Activate/Focus" } },
    { nil, "\\", Notes.toggleFolderView, { "View", "Show Folders" } },
    { nil, "l", Notes.search, { "Edit", "Find..." } },
    { nil, "n", Notes.newNote, { "File", "New Note" } },
    { nil, "1", Notes.toggleAttachmentsBrowser, { "File", "Toggle Attachments Browser" } },
    { { "shift" }, "f", Notes.search, { "Edit", "Find..." } },
    { { "shift" }, "n", Notes.newFolder, { "File", "New Folder" } },
})

return Notes
