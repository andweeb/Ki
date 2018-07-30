local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Notes = Entity:subclass("Notes")

function Notes.getSelectionItems()
    local choices = {}
    local isOk, notes, rawTable =
    hs.osascript.applescript(Notes.renderScriptTemplate("notes"))

    if not isOk then
        Notes.notifyError("Error fetching Notes", rawTable.NSLocalizedFailureReason)

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

function Notes.focus(app, choice)
    app:activate()

    if choice then
        local isOk, _, rawTable = hs.osascript.applescript([[
            tell application "Notes" to show note id "]]..choice.noteId..[["
        ]])

        if not isOk then
            Notes.notifyError("Error selecting the note", rawTable.NSLocalizedFailureReason)
        end
    end
end

function Notes.toggleFolderView(app)
    Notes.focus(app)
    _ = app:selectMenuItem("Show Folders") or app:selectMenuItem("Hide Folders")
end

function Notes.search(app)
    app:selectMenuItem("Search")
end

function Notes.newNote(app)
    app:selectMenuItem("New Note")
end

function Notes.newFolder(app)
    app:selectMenuItem("New Folder")
end

function Notes.toggleAttachmentsBrowser(app)
    _ = app:selectMenuItem("Show Attachments Browser") or app:selectMenuItem("Hide Attachments Browser")
end

function Notes:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "\\", self.toggleFolderView, { "View", "Show Folders" } },
        { nil, "l", self.search, { "Edit", "Find..." } },
        { nil, "n", self.newNote, { "File", "New Note" } },
        { nil, "1", self.toggleAttachmentsBrowser, { "File", "Toggle Attachments Browser" } },
        { { "cmd" }, "f", self.search, { "Edit", "Find..." } },
        { { "shift" }, "n", self.newFolder, { "File", "New Folder" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Notes", shortcuts)
end

return Notes
