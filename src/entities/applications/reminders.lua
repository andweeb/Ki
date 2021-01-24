----------------------------------------------------------------------------------------------------
-- Reminders application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Reminders",
    shortcuts = {
        Reminders = {
            { nil, ",", FocusAndSelectMenuItem { "Reminders", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "Reminders", "Hide Reminders" } },
            { nil, "q", FocusAndSelectMenuItem { "Reminders", "Quit Reminders" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Reminders", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Reminders", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Reminders", "About Reminders" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Reminders", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Reminders", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Reminder" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { { "shift" }, "n", FocusAndSelectMenuItem { "File", "New List" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "New Group" } },
        },
        Edit = {
            { nil, "[", FocusAndSelectMenuItem { "Edit", "Outdent Reminder" } },
            { nil, "]", FocusAndSelectMenuItem { "Edit", "Indent Reminder" } },
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "e", FocusAndSelectMenuItem { "Edit", "Show All Subtasks" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Find" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "e", FocusAndSelectMenuItem { "Edit", "Hide All Subtasks" } },
            { { "shift" }, "f", FocusAndSelectMenuItem { "Edit", "Clear Flag" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Set Priority" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Substitutions" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Transformations" } },
        },
        View = {
            { nil, "i", FocusAndToggleMenuItem { "Show Info", "Hide Info" } },
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { { "ctrl" }, "s", FocusAndToggleMenuItem { "Show Sidebar", "Hide Sidebar" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "View", "Sort By" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Reminders" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Reminders Help" } },
        },
    },
}
