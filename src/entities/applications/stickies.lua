----------------------------------------------------------------------------------------------------
-- Stickies application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Stickies",
    shortcuts = {
        Stickies = {
            { nil, "h", FocusAndSelectMenuItem { "Stickies", "Hide Stickies" } },
            { nil, "q", FocusAndSelectMenuItem { "Stickies", "Quit Stickies" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Stickies", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Stickies", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Stickies", "About Stickies" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Stickies", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Stickies", "Show All" } },
        },
        File = {
            { nil, "n", FocusAndSelectMenuItem { "File", "New Note" } },
            { nil, "p", FocusAndSelectMenuItem { "File", "Print…" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export All to Notes…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Export Text…" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Import Text…" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "k", FocusAndSelectMenuItem { "Edit", "Add Link..." } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", FocusAndSelectMenuItem { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Substitutions" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Transformations" } },
        },
        Font = {
            { nil, "+", FocusAndSelectMenuItem { "Font", "Bigger" } },
            { nil, "-", FocusAndSelectMenuItem { "Font", "Smaller" } },
            { nil, "b", FocusAndSelectMenuItem { "Font", "Bold" } },
            { nil, "i", FocusAndSelectMenuItem { "Font", "Italic" } },
            { nil, "t", FocusAndToggleMenuItem { "Show Fonts", "Hide Fonts" } },
            { nil, "u", FocusAndSelectMenuItem { "Font", "Underline" } },
            { { "alt" }, "c", FocusAndSelectMenuItem { "Font", "Copy Style" } },
            { { "alt" }, "v", FocusAndSelectMenuItem { "Font", "Paste Style" } },
            { { "shift" }, "c", FocusAndToggleMenuItem { "Show Colors", "Hide Colors" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Font", "Baseline" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Font", "Kern" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Font", "Ligature" } },
        },
        Color = {
            { nil, "1", FocusAndSelectMenuItem { "Color", "Yellow" } },
            { nil, "2", FocusAndSelectMenuItem { "Color", "Blue" } },
            { nil, "3", FocusAndSelectMenuItem { "Color", "Green" } },
            { nil, "4", FocusAndSelectMenuItem { "Color", "Pink" } },
            { nil, "5", FocusAndSelectMenuItem { "Color", "Purple" } },
            { nil, "6", FocusAndSelectMenuItem { "Color", "Gray" } },
        },
        Window = {
            { nil, "m", FocusAndToggleMenuItem { "Collapse", "Expand" } },
            { { "alt" }, "f", FocusAndSelectMenuItem { "Window", "Float on Top" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { { "alt" }, "t", FocusAndSelectMenuItem { "Window", "Translucent" } },
            { { "alt" }, "z", FocusAndSelectMenuItem { "Window", "Undo Arrange" } },
            { { "shift" }, "m", FocusAndSelectMenuItem { "Window", "Zoom" } },
            { { "shift", "alt" }, "m", FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { { "shift", "alt" }, "z", FocusAndSelectMenuItem { "Window", "Redo Arrange" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Window", "Arrange By" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Use as Default" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Stickies Help" } },
        },
    },
}
