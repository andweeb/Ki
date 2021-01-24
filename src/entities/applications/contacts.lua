----------------------------------------------------------------------------------------------------
-- Contacts application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Contacts",
    shortcuts = {
        Contacts = {
            { nil, ",", FocusAndSelectMenuItem { "Contacts", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "Contacts", "Hide Contacts" } },
            { nil, "q", FocusAndSelectMenuItem { "Contacts", "Quit Contacts" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Contacts", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Contacts", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Contacts", "About Contacts" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Contacts", "Accounts..." } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Contacts", "Add Account..." } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Contacts", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Contacts", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Card" } },
            { nil, "o", FocusAndSelectMenuItem { "File", "Import…" } },
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "s", FocusAndSelectMenuItem { "File", "Save" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "n", FocusAndSelectMenuItem { "File", "New Smart Group…" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { { "shift" }, "n", FocusAndSelectMenuItem { "File", "New Group" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export as PDF…" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Export" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "New Group From Selection" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "New Smart Group from Current Search" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "l", FocusAndSelectMenuItem { "Edit", "Edit Card" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Edit Distribution List…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Edit Smart Group" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Remove From Group" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Rename Group" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Spotlight:.*" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "1", FocusAndToggleMenuItem { "Show Groups", "Hide Groups" } },
            { { "alt" }, "1", FocusAndToggleMenuItem { "Show Groups", "Hide Groups" } },
            { { "alt" }, "l", FocusAndToggleMenuItem { "Show Last Import", "Hide Last Import" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, "1", FocusAndSelectMenuItem { "View", "Hide Groups" } },
        },
        Card = {
            { nil, "[", FocusAndSelectMenuItem { "Card", "Go to Previous Card" } },
            { nil, "\\", FocusAndToggleMenuItem { "Mark as a Company", "Mark as a Person" } },
            { nil, "]", FocusAndSelectMenuItem { "Card", "Go to Next Card" } },
            { nil, "i", FocusAndSelectMenuItem { "Card", "Open in Separate Window" } },
            { { "alt" }, "i", FocusAndSelectMenuItem { "Card", "Choose Custom Image…" } },
            { { "shift" }, "l", FocusAndSelectMenuItem { "Card", "Merge Selected Cards " } },
            { { "shift" }, "m", FocusAndSelectMenuItem { "Card", "Go to My Card" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Card", "Add Field" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Card", "Clear Custom Image" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Card", "Look for Duplicates…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Card", "Make This My Card" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Last Name Before First", "Show First Name Before Last" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Card", "Share My Card" } },
        },
        Window = {
            { nil, "0", FocusAndSelectMenuItem { "Window", "Contacts" } },
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Contacts Help" } },
        },
    },
}
