----------------------------------------------------------------------------------------------------
-- TV application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "TV",
    shortcuts = {
        TV = {
            { nil, ",", SelectMenuItemAndFocus { "TV", "Preferences…" } },
            { nil, "h", SelectMenuItemAndFocus { "TV", "Hide TV" } },
            { nil, "q", SelectMenuItemAndFocus { "TV", "Quit TV" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "TV", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "TV", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "TV", "About TV" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "TV", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "TV", "Show All" } },
        },
        File = {
            { nil, "o", SelectMenuItemAndFocus { "File", "Import…" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close Window" } },
            { { "shift" }, "r", SelectMenuItemAndFocus { "File", "Show in Finder" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Library" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "New" } },
        },
        Edit = {
            { nil, "a", SelectMenuItemAndFocus { "Edit", "Select All" } },
            { nil, "c", SelectMenuItemAndFocus { "Edit", "Copy" } },
            { nil, "v", SelectMenuItemAndFocus { "Edit", "Paste" } },
            { nil, "x", SelectMenuItemAndFocus { "Edit", "Cut" } },
            { nil, "z", SelectMenuItemAndFocus { "Edit", "Undo" } },
            { { "shift" }, "a", SelectMenuItemAndFocus { "Edit", "Deselect All" } },
            { { "shift" }, "z", SelectMenuItemAndFocus { "Edit", "Redo" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Start Dictation" } },
        },
        Video = {
            { nil, "i", SelectMenuItemAndFocus { "Video", "Info…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Add to Device" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Add to Playlist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Check Selection" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Delete from Library" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Download" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Mark as Watched" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Remove from Playlist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Share" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Show in Playlist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Uncheck Selection" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Video", "Video Quality" } },
        },
        View = {
            { nil, "/", SelectMenuItemAndFocus { "View", "Show Status Bar" } },
            { nil, "j", SelectMenuItemAndFocus { "View", "Show View Options" } },
            { { "alt" }, "f", SelectMenuItemAndFocus { "View", "Show Filter Field" } },
            { { "ctrl" }, "f", ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
        },
        Controls = {
            { nil, "[", SelectMenuItemAndFocus { "Controls", "Back" } },
            { nil, "r", SelectMenuItemAndFocus { "Controls", "Reload Page" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Controls", "Decrease Volume" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Controls", "Increase Volume" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Controls", "Next" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Controls", "Play" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Controls", "Previous" } },
        },
        Account = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Andrew Kwon" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Account", "Authorizations" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Check for Available Downloads…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Purchased" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Redeem…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Sign Out" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "View My Account…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "andrewshky@gmail.com" } },
        },
        Window = {
            { nil, "0", SelectMenuItemAndFocus { "Window", "TV" } },
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { { "alt" }, "l", SelectMenuItemAndFocus { "Window", "Activity" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "About TV & Privacy" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Apple Service and Support" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Keyboard Shortcuts" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "TV Help" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "What Happened to iTunes?" } },
        },
    },
}
