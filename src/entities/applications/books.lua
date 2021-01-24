----------------------------------------------------------------------------------------------------
-- Books application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Books",
    shortcuts = {
        Books = {
            { nil, ",", FocusAndSelectMenuItem { "Books", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "Books", "Hide Books" } },
            { nil, "q", FocusAndSelectMenuItem { "Books", "Quit Books" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Books", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Books", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Books", "About Books" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Books", "Provide Books Feedback" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Books", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Books", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Collection" } },
            { nil, "o", FocusAndSelectMenuItem { "File", "Open Book" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "shift" }, "o", FocusAndSelectMenuItem { "File", "Add to Library…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Add to Collection" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Move to Collection" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "New Collection from Selection" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Open Recent" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Share" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "d", FocusAndSelectMenuItem { "Edit", "Bookmark Page" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Add Note" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Highlight" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "+", FocusAndSelectMenuItem { "View", "Zoom In" } },
            { nil, "-", FocusAndSelectMenuItem { "View", "Zoom Out" } },
            { nil, "0", FocusAndSelectMenuItem { "View", "Actual Size" } },
            { nil, "1", FocusAndSelectMenuItem { "View", "Single Page" } },
            { nil, "2", FocusAndSelectMenuItem { "View", "Two Pages" } },
            { nil, "3", FocusAndSelectMenuItem { "View", "Show Notes in Margins" } },
            { nil, "4", FocusAndSelectMenuItem { "View", "Show Notes Panel" } },
            { nil, "5", FocusAndSelectMenuItem { "View", "Show Study Cards" } },
            { nil, "6", FocusAndSelectMenuItem { "View", "Show Glossary" } },
            { nil, "t", FocusAndSelectMenuItem { "View", "Show Table of Contents" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, "t", FocusAndSelectMenuItem { "View", "Show Thumbnails" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Show Title & Author" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Show iCloud Books" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Sort By" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Theme" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "View As" } },
        },
        Controls = {
            { nil, ".", FocusAndSelectMenuItem { "Controls", "Stop" } },
            { nil, "[", FocusAndSelectMenuItem { "Controls", "Back" } },
            { nil, "]", FocusAndSelectMenuItem { "Controls", "Forward" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Controls", "Next Chapter" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Controls", "Play" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Controls", "Playback Speed" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Controls", "Previous Chapter" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Controls", "Skip Back" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Controls", "Skip Forward" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Controls", "Sleep Timer" } },
        },
        Store = {
            { nil, "r", FocusAndSelectMenuItem { "Store", "Reload" } },
            { { "shift" }, "a", FocusAndSelectMenuItem { "Store", "Audiobook Store Home" } },
            { { "shift" }, "b", FocusAndSelectMenuItem { "Store", "Book Store Home" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Store", "Authorizations" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Store", "Check for Available Downloads…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Store", "Sign Out" } },
            { unmapped, unmapped, FocusAndSelectMenuItem "View My Apple ID (.*)…" },
        },
        Window = {
            { nil, "l", FocusAndSelectMenuItem { "Window", "Library" } },
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Books" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Books Help" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Keyboard Shortcuts" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Service and Support" } },
        },
    },
}
