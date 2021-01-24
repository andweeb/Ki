----------------------------------------------------------------------------------------------------
-- FaceTime application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "FaceTime",
    shortcuts = {
        FaceTime = {
            { nil, ",", FocusAndSelectMenuItem { "FaceTime", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "FaceTime", "Hide FaceTime" } },
            { nil, "k", FocusAndSelectMenuItem { "FaceTime", "Turn FaceTime Off" } },
            { nil, "q", FocusAndSelectMenuItem { "FaceTime", "Quit FaceTime" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "FaceTime", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "FaceTime", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "FaceTime", "About FaceTime" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "FaceTime", "Remove All Recents" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "FaceTime", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "FaceTime", "Show All" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Find" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        Video = {
            { nil, "r", FocusAndToggleMenuItem { "Use Portrait", "Use Landscape" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Video", "Always on Top" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Video", "MacBook Air Microphone" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Video", "MacBook Air Speakers" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Video", "Mute" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { nil, "w", FocusAndSelectMenuItem { "Window", "Close" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "Window", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem "FaceTime with .*" },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "FaceTime Help" } },
        },
    },
}
