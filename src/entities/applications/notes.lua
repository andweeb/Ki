----------------------------------------------------------------------------------------------------
-- Notes application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local search = Application.createMenuItemEvent("Search", { focusBefore = true })
local newNote = Application.createMenuItemEvent("New Note", { focusBefore = true })
local newFolder = Application.createMenuItemEvent("New Folder", { focusBefore = true })
local toggleFolderView = Application.createMenuItemEvent({ "Show Folders", "Hide Folders" }, {
    isToggleable = true,
    focusBefore = true,
})
local toggleAttachmentsBrowser = Application.createMenuItemEvent({
    "Show Attachments Browser",
    "Hide Attachments Browser"
}, { isToggleable = true })

-- Implement method to support selection of notes in select mode
local function getChooserItems()
    local choices = {}

    local script = Application.renderScriptTemplate("notes", { action = "get-notes" })
    local isOk, notes, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error fetching Notes", rawTable.NSLocalizedFailureReason)
    end

    for _, note in pairs(notes) do
        table.insert(choices, {
            noteId = note.noteId,
            text = note.noteName,
            subText = "Last modified "..note.lastModified,
        })
    end

    return choices
end

-- Action to activate the Notes app or open a particular note
local function focus(app, choice)
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

return Application {
    name = "Notes",
    getChooserItems = getChooserItems,
    shortcuts = {
        { nil, nil, focus, "Activate" },
        { nil, "\\", toggleFolderView, "Show Folders" },
        { nil, "l", search, "Find..." },
        { nil, "n", newNote, "New Note" },
        { nil, "1", toggleAttachmentsBrowser, "Toggle Attachments Browser" },
        { { "shift" }, "f", search, "Find..." },
        { { "shift" }, "n", newFolder, "New Folder" },
    },
}
