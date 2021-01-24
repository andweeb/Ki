----------------------------------------------------------------------------------------------------
-- Activity Monitor application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Activity Monitor",
    shortcuts = {
        ["Activity Monitor"] = {
            { nil, "h", FocusAndSelectMenuItem { "Activity Monitor", "Hide Activity Monitor" } },
            { nil, "q", FocusAndSelectMenuItem { "Activity Monitor", "Quit Activity Monitor" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Activity Monitor", "Hide Others" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Activity Monitor", "About Activity Monitor" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Activity Monitor", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Activity Monitor", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Activity Monitor", "Show All" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "alt" }, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        File = {
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { { "shift" }, "p", FocusAndSelectMenuItem { "File", "Page Setup…" } },
        },
        View = {
            { nil, "i", FocusAndSelectMenuItem { "View", "Inspect Process" } },
            { nil, "k", FocusAndSelectMenuItem { "View", "Clear CPU History" } },
            { { "alt" }, "f", FocusAndSelectMenuItem { "View", "Filter Processes" } },
            { { "alt" }, "j", FocusAndSelectMenuItem { "View", "Show Deltas for Process" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "View", "Quit Process" } },
            { { "alt" }, "s", FocusAndSelectMenuItem { "View", "Sample Process" } },
            { { "alt", "ctrl" }, "s", FocusAndSelectMenuItem { "View", "Run Spindump" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Active Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "All Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "All Processes, Hierarchically" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Applications in last 12 hours" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Columns" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Dock Icon" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "GPU Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Inactive Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "My Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Other User Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Processes, by GPU" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Run System Diagnostics…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Selected Processes" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Send Signal to Process…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "System Processes" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Update Frequency" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "View", "Windowed Processes" } },
        },
        Window = {
            { nil, "1", FocusAndSelectMenuItem { "Window", "Activity Monitor" } },
            { nil, "2", FocusAndSelectMenuItem { "Window", "CPU Usage" } },
            { nil, "3", FocusAndSelectMenuItem { "Window", "CPU History" } },
            { nil, "4", FocusAndSelectMenuItem { "Window", "GPU History" } },
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Activity Monitor (All Processes)" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Keep CPU Windows on Top" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Activity Monitor Help" } },
        },
    },
}
