----------------------------------------------------------------------------------------------------
-- System Preferences application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "System Preferences",
    shortcuts = {
        ["System Preferences"] = {
            { nil, "h", FocusAndSelectMenuItem { "System Preferences", "Hide System Preferences" } },
            { nil, "q", FocusAndSelectMenuItem { "System Preferences", "Quit System Preferences" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "System Preferences", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "System Preferences", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "System Preferences", "About System Preferences" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "System Preferences", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "System Preferences", "Show All" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Clear" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "[", FocusAndSelectMenuItem { "View", "Back" } },
            { nil, "]", FocusAndSelectMenuItem { "View", "Forward" } },
            { nil, "f", FocusAndSelectMenuItem { "View", "Search" } },
            { nil, "l", FocusAndSelectMenuItem { "View", "Show All Preferences" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Accessibility" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Apple ID" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Bluetooth" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Customize..." } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Date & Time" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Desktop & Screen Saver" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Displays" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Dock" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Energy Saver" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Extensions" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Family Sharing" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "General" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Internet Accounts" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Keyboard" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Language & Region" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Mission Control" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Mouse" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Network" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Notifications" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Organize Alphabetically" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Organize by Categories" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Printers & Scanners" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Screen Time" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Security & Privacy" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Sharing" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Siri" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Software Update" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Sound" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Spotlight" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Startup Disk" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Time Machine" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Touch ID" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Trackpad" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Users & Groups" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Wallet & Apple Pay" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { nil, "w", FocusAndSelectMenuItem { "Window", "Close" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "Window", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "System Preferences" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "System Preferences Help" } },
        },
    },
}
