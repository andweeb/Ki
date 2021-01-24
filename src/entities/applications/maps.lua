----------------------------------------------------------------------------------------------------
-- Maps application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Maps",
    shortcuts = {
        Maps = {
            { nil, "h", FocusAndSelectMenuItem { "Maps", "Hide Maps" } },
            { nil, "q", FocusAndSelectMenuItem { "Maps", "Quit Maps" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Maps", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Maps", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Maps", "About Maps" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Maps", "Email Preferences…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Maps", "Report an Issue…" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Maps", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Maps", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Window" } },
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "t", FocusAndSelectMenuItem { "File", "New Tab" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close Window" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export as PDF…" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "File", "Share" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Find…" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "alt" }, "c", FocusAndSelectMenuItem { "Edit", "Copy Link" } },
            { { "shift" }, "d", FocusAndSelectMenuItem { "Edit", "Drop Pin" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "+", FocusAndSelectMenuItem { "View", "Zoom In" } },
            { nil, "-", FocusAndSelectMenuItem { "View", "Zoom Out" } },
            { nil, "1", FocusAndSelectMenuItem { "View", "Map" } },
            { nil, "2", FocusAndSelectMenuItem { "View", "Transit" } },
            { nil, "3", FocusAndSelectMenuItem { "View", "Satellite" } },
            { nil, "l", FocusAndSelectMenuItem { "View", "Go to Current Location" } },
            { nil, "r", FocusAndToggleMenuItem { "Show Directions", "Hide Directions" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, "\\", FocusAndToggleMenuItem { "Show All Tabs", "Exit Tab Overview" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Directions" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Distances" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Labels" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Air Quality Index", "Hide Air Quality Index" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Labels", "Hide Labels" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Scale", "Hide Scale" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Tab Bar", "Hide Tab Bar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Show Traffic" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Show Weather Conditions", "Hide Weather Conditions" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Snap to North" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Use Dark Map" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Merge All Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Tab to New Window" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Show Next Tab" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Show Previous Tab" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Maps Help" } },
        },
    },
}
