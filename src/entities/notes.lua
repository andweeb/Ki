local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    toggleFolderView = Application.createMenuItemEvent({ "Show Folders", "Hide Folders" }, {
        isToggleable = true,
        focusBefore = true,
    }),
    toggleAttachmentsBrowser = Application.createMenuItemEvent({
        "Show Attachments Browser",
        "Hide Attachments Browser"
    }, { isToggleable = true }),
    search = Application.createMenuItemEvent("Search", { focusAfter = true }),
    newNote = Application.createMenuItemEvent("New Note", { focusAfter = true }),
    newFolder = Application.createMenuItemEvent("New Folder", { focusAfter = true }),
}

function Application.getSelectionItems()
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

function actions.focus(app, choice)
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

local shortcuts = {
    { nil, nil, actions.focus, { "Notes", "Activate/Focus" } },
    { nil, "\\", actions.toggleFolderView, { "View", "Show Folders" } },
    { nil, "l", actions.search, { "Edit", "Find..." } },
    { nil, "n", actions.newNote, { "File", "New Note" } },
    { nil, "1", actions.toggleAttachmentsBrowser, { "File", "Toggle Attachments Browser" } },
    { { "cmd" }, "f", actions.search, { "Edit", "Find..." } },
    { { "shift" }, "n", actions.newFolder, { "File", "New Folder" } },
}

return Application:new("Notes", shortcuts)
