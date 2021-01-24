----------------------------------------------------------------------------------------------------
-- App Store application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "App Store",
    shortcuts = {
        ["App Store"] = {
            { nil, ",", FocusAndSelectMenuItem { "App Store", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "App Store", "Hide App Store" } },
            { nil, "q", FocusAndSelectMenuItem { "App Store", "Quit App Store" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "App Store", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "App Store", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "App Store", "About App Store" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "App Store", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "App Store", "Show All" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", FocusAndSelectMenuItem { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        Store = {
            { nil, "0", FocusAndSelectMenuItem "View My Account (.*)…" },
            { nil, "1", FocusAndSelectMenuItem { "Store", "Discover" } },
            { nil, "2", FocusAndSelectMenuItem { "Store", "Arcade" } },
            { nil, "3", FocusAndSelectMenuItem { "Store", "Create" } },
            { nil, "4", FocusAndSelectMenuItem { "Store", "Work" } },
            { nil, "5", FocusAndSelectMenuItem { "Store", "Play" } },
            { nil, "6", FocusAndSelectMenuItem { "Store", "Develop" } },
            { nil, "7", FocusAndSelectMenuItem { "Store", "Categories" } },
            { nil, "8", FocusAndSelectMenuItem { "Store", "Updates" } },
            { nil, "[", FocusAndSelectMenuItem { "Store", "Back" } },
            { nil, "f", FocusAndSelectMenuItem { "Store", "Search" } },
            { nil, "r", FocusAndSelectMenuItem { "Store", "Reload Page" } },
            { { "shift" }, "s", FocusAndSelectMenuItem { "Store", "See All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Store", "Sign Out" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { nil, "w", FocusAndSelectMenuItem { "Window", "Close" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "Window", "Close All" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "App Store" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "About App Store & Privacy" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "App Store Help" } },
        },
    },
}
