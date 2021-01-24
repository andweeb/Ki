----------------------------------------------------------------------------------------------------
-- Photo Booth application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Photo Booth",
    shortcuts = {
        ["Photo Booth"] = {
            { nil, "h", FocusAndSelectMenuItem { "Photo Booth", "Hide Photo Booth" } },
            { nil, "q", FocusAndSelectMenuItem { "Photo Booth", "Quit Photo Booth" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Photo Booth", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Photo Booth", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Photo Booth", "About Photo Booth" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Photo Booth", "Show All" } },
        },
        File = {
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export Original..." } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export..." } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Take Photo" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Flip Photo" } },
            { nil, "t", FocusAndSelectMenuItem { "Edit", "Trim Movie…" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Auto Flip New Items" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete All…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "1", FocusAndSelectMenuItem { "View", "Show Photo" } },
            { nil, "2", FocusAndSelectMenuItem { "View", "Show Effects" } },
            { nil, "3", FocusAndSelectMenuItem { "View", "Show Last Effect" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, "r", FocusAndSelectMenuItem { "View", "Reset Effect" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Next Page of Effects" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Previous Page of Effects" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Start Slideshow" } },
        },
        Camera = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Camera", "Enable Screen Flash" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Camera", "FaceTime HD Camera (Built-in)" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { nil, "w", FocusAndSelectMenuItem { "Window", "Close" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "Window", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Photo Booth" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Photo Booth Help" } },
        },
    },
}
