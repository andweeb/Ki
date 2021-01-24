----------------------------------------------------------------------------------------------------
-- Notes application config
--
local Ki = spoon.Ki
local Action = Ki.Action
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

-- Action to activate the Notes app or open a particular note
local Focus = Action {
    name = "Activate",
    action = function(app, choice)
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
}

return Application {
    name = "Notes",
    shortcuts = {
        Notes = {
            { nil, nil, Focus },
            { nil, ",", FocusAndSelectMenuItem { "Notes", "Preferences…" } },
            { nil, "h", FocusAndToggleMenuItem { "Show Notes", "Hide Notes" } },
            { nil, "q", FocusAndSelectMenuItem { "Notes", "Quit Notes" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Notes", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Notes", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Notes", "About Notes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Notes", "Accounts…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Notes", "Close All Locked Notes" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Notes", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Notes", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Note" } },
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { { "shift" }, "n", FocusAndSelectMenuItem { "File", "New Folder" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Add People To…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export as PDF…" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Import from iPhone" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Import to Notes…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Lock Note" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Pin Note" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Share" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "k", FocusAndSelectMenuItem { "Edit", "Add Link…" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "a", FocusAndSelectMenuItem { "Edit", "Attach File…" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", FocusAndSelectMenuItem { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Paste and Retain Style" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Rename Attachment…" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Substitutions" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Transformations" } },
        },
        Format = {
            { { "alt" }, "t", FocusAndSelectMenuItem { "Format", "Table" } },
            { { "shift" }, "b", FocusAndSelectMenuItem { "Format", "Body" } },
            { { "shift" }, "h", FocusAndSelectMenuItem { "Format", "Heading" } },
            { { "shift" }, "j", FocusAndSelectMenuItem { "Format", "Subheading" } },
            { { "shift" }, "l", FocusAndSelectMenuItem { "Format", "Checklist" } },
            { { "shift" }, "m", FocusAndSelectMenuItem { "Format", "Monospaced" } },
            { { "shift" }, "t", FocusAndSelectMenuItem { "Format", "Title" } },
            { { "shift" }, "u", FocusAndSelectMenuItem { "Format", "Mark as Checked" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Format", "Bulleted List" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Format", "Convert To Text" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Format", "Dashed List" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Format", "Font" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Format", "Indentation" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Format", "More" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Format", "Move List Item" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Format", "Numbered List" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Note with Light Background", "Show Note with Dark Background" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Format", "Text" } },
        },
        View = {
            { nil, "1", FocusAndSelectMenuItem { "View", "as List" } },
            { nil, "2", FocusAndSelectMenuItem { "View", "as Gallery" } },
            { nil, "3", FocusAndToggleMenuItem { "Show Attachments Browser", "Hide Attachments Browser" } },
            { { "alt" }, "s", FocusAndToggleMenuItem { "Show Folders", "Hide Folders" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, ",", FocusAndSelectMenuItem { "View", "Zoom Out" } },
            { { "shift" }, ".", FocusAndSelectMenuItem { "View", "Zoom In" } },
            { { "shift" }, "0", FocusAndSelectMenuItem { "View", "Actual Size" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Customize Toolbar…" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Note Count", "Hide Note Count" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Toolbar", "Hide Toolbar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Show in Note" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Sort Folder By" } },
        },
        Window = {
            { nil, "0", FocusAndSelectMenuItem { "Window", "Notes" } },
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt", "ctrl" }, "z", FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { { "ctrl" }, "z", FocusAndSelectMenuItem { "Window", "Zoom" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Float Selected Note" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Photo Browser" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Notes Help" } },
        },
    },
    -- Implement method to support selection of notes in select mode
    getChooserItems = function()
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
}
