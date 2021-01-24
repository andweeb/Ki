----------------------------------------------------------------------------------------------------
-- Spotify application config
--
local Ki = spoon.Ki
local Action = Ki.Action
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Spotify",
    shortcuts = {
        Spotify = {
            { nil, ",", FocusAndSelectMenuItem { "Spotify", "Preferences" } },
            { nil, "h", FocusAndSelectMenuItem { "Spotify", "Hide Spotify" } },
            { nil, "q", FocusAndSelectMenuItem { "Spotify", "Quit Spotify" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Spotify", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Spotify", "Quit and Keep Windows" } },
            { { "shift" }, "w", FocusAndSelectMenuItem { "Spotify", "Log Out" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Spotify", "About Spotify" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Spotify", "Hardware Acceleration" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Spotify", "Offline Mode" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Spotify", "Private Session" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Spotify", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Spotify", "Show All" } },
        },
        File = {
            { { "shift" }, "n", FocusAndSelectMenuItem { "File", "New Playlist" } },
            { { "cmd", "shift" }, "n", FocusAndSelectMenuItem { "File", "New Playlist Folder" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Filter" } },
            { nil, "l", FocusAndSelectMenuItem { "Edit", "Search" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "+", FocusAndSelectMenuItem { "View", "Zoom In" } },
            { nil, "-", FocusAndSelectMenuItem { "View", "Zoom Out" } },
            { nil, "0", FocusAndSelectMenuItem { "View", "Actual Size" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Fullscreen", "Exit Fullscreen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Friend Activity" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Go Back" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Go Forward" } },
        },
        Playback = {
            { nil, "space", Action { "Toggle Play", hs.spotify.playpause } },
            { nil, "n", Action { "Previous", hs.spotify.next } },
            { nil, "p", Action { "Previous", hs.spotify.previous } },
            { nil, "r", FocusAndSelectMenuItem { "Playback", "Repeat" } },
            { nil, "s", FocusAndSelectMenuItem { "Playback", "Shuffle" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Next" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Play" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Previous" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Seek Backward" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Seek Forward" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Volume Down" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Playback", "Volume Up" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { nil, "w", FocusAndSelectMenuItem { "Window", "Close" } },
            { { "alt" }, "1", FocusAndSelectMenuItem { "Window", "Spotify" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "Window", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Spotify Community" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Spotify Help" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Third-party Software" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Your Account" } },
        },
    },
}
