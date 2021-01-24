----------------------------------------------------------------------------------------------------
-- Music application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItem = Application.ChooseMenuItem
local SelectMenuItem = Application.SelectMenuItem
local ToggleMenuItem = Application.ToggleMenuItem
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "Music",
    shortcuts = {
        Music = {
            { nil, ",", SelectMenuItemAndFocus { "Music", "Preferences…" } },
            { nil, "h", SelectMenuItemAndFocus { "Music", "Hide Music" } },
            { nil, "q", SelectMenuItemAndFocus { "Music", "Quit Music" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "Music", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "Music", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Music", "About Music" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Music", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Music", "Show All" } },
        },
        File = {
            { nil, "o", SelectMenuItemAndFocus { "File", "Import…" } },
            { nil, "p", SelectMenuItemAndFocus { "File", "Print…" } },
            { nil, "u", SelectMenuItemAndFocus { "File", "Open Stream URL…" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close Window" } },
            { { "shift" }, "r", SelectMenuItemAndFocus { "File", "Show in Finder" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Burn Playlist to Disc…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Convert" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Library" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "New" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Page Setup…" } },
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
        Song = {
            { nil, "i", SelectMenuItemAndFocus { "Song", "Info…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Add to Device" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Add to Library" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Song", "Add to Playlist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Create Station" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Delete from Library" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Play Later" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Play Next" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Remove from Playlist" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Song", "Share Artist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Show in Playlist" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Song", "Show in iTunes Store" } },
        },
        View = {
            { nil, "/", ToggleMenuItemAndFocus { "Show Status Bar", "Hide Status Bar" } },
            { nil, "j", ToggleMenuItemAndFocus { "Show View Options", "Hide View Options" } },
            { { "alt" }, "f", ToggleMenuItemAndFocus { "Show Filter Field", "Hide Filter Field" } },
            { { "alt" }, "u", ToggleMenuItemAndFocus { "Show Playing Next", "Hide Playing Next" } },
            { { "ctrl" }, "f", ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
            { { "ctrl" }, "u", ToggleMenuItemAndFocus { "Show Lyrics", "Hide Lyrics" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "All Music" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Only Downloaded Music" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "View", "Sort Albums By" } },
        },
        Controls = {
            { nil, "space", ToggleMenuItem { "Play", "Pause" } },
            { nil, ".", SelectMenuItem { "Controls", "Stop" } },
            { nil, "[", SelectMenuItem { "Controls", "Back" } },
            { nil, "l", SelectMenuItem { "Controls", "Go to Current Song" } },
            { nil, "r", SelectMenuItem { "Controls", "Reload Page" } },
            { unmapped, unmapped, SelectMenuItem { "Controls", "Decrease Volume" } },
            { unmapped, unmapped, SelectMenuItem { "Controls", "Genius Shuffle" } },
            { unmapped, unmapped, SelectMenuItem { "Controls", "Increase Volume" } },
            { unmapped, unmapped, SelectMenuItem { "Controls", "Next" } },
            { unmapped, unmapped, SelectMenuItem { "Controls", "Previous" } },
            { unmapped, unmapped, ChooseMenuItem { "Controls", "Repeat" } },
            { unmapped, unmapped, ChooseMenuItem { "Controls", "Shuffle" } },
        },
        Account = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Andrew Kwon" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Account", "Authorizations" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Check for Available Downloads…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Join Apple Music…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Purchased" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Redeem…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Sign Out" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "View My Account…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "Wish List" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Account", "andrewshky@gmail.com" } },
        },
        Window = {
            { nil, "0", SelectMenuItemAndFocus { "Window", "Music" } },
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { nil, "t", SelectMenuItemAndFocus { "Window", "Visualizer" } },
            { { "alt" }, "e", SelectMenuItemAndFocus { "Window", "Equalizer" } },
            { { "alt" }, "l", SelectMenuItemAndFocus { "Window", "Activity" } },
            { { "alt" }, "m", SelectMenuItemAndFocus { "Window", "MiniPlayer" } },
            { { "shift" }, "f", SelectMenuItemAndFocus { "Window", "Full Screen Player" } },
            { { "shift" }, "m", ToggleMenuItemAndFocus { "Switch to MiniPlayer", "Switch from MiniPlayer" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Window", "Visualizer Settings" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "About Apple Music & Privacy" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "About iTunes Store & Privacy" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Apple Service and Support" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Keyboard Shortcuts" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Music Help" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "What Happened to iTunes?" } },
        },
    },
}
