----------------------------------------------------------------------------------------------------
-- Dictionary application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Dictionary",
    shortcuts = {
        Dictionary = {
            { nil, ",", FocusAndSelectMenuItem { "Dictionary", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "Dictionary", "Hide Dictionary" } },
            { nil, "q", FocusAndSelectMenuItem { "Dictionary", "Quit Dictionary" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Dictionary", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Dictionary", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Dictionary", "About Dictionary" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Dictionary", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Dictionary", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Window" } },
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "t", FocusAndSelectMenuItem { "File", "New Tab" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Open Dictionaries Folder" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
        },
        Go = {
            { nil, "[", FocusAndSelectMenuItem { "Go", "Back" } },
            { nil, "]", FocusAndSelectMenuItem { "Go", "Forward" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Go", "Front/Back Matter" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "shift" }, "\\", FocusAndSelectMenuItem { "Window", "Show All Tabs" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "English Thesaurus" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "English Thesaurus" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Merge All Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Tab to New Window" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Show Next Tab" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Show Previous Tab" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Show Tab Bar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Dictionary Help" } },
        },
    },
}
