----------------------------------------------------------------------------------------------------
-- Voice Memos application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local FocusAndChooseMenuItem = Application.FocusAndChooseMenuItem
local FocusAndSelectMenuItem = Application.FocusAndSelectMenuItem
local FocusAndToggleMenuItem = Application.FocusAndToggleMenuItem
local unmapped = Application.unmapped

return Application {
    name = "Voice Memos",
    shortcuts = {
        ["Voice Memos"] = {
            { nil, ",", FocusAndSelectMenuItem { "Voice Memos", "Preferences…" } },
            { nil, "h", FocusAndSelectMenuItem { "Voice Memos", "Hide Voice Memos" } },
            { nil, "q", FocusAndSelectMenuItem { "Voice Memos", "Quit Voice Memos" } },
            { { "alt" }, "h", FocusAndSelectMenuItem { "Voice Memos", "Hide Others" } },
            { { "alt" }, "q", FocusAndSelectMenuItem { "Voice Memos", "Quit and Keep Windows" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Voice Memos", "About Voice Memos" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Voice Memos", "Services" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Voice Memos", "Show All" } },
        },
        File = {
            { nil, "space", FocusAndSelectMenuItem { "File", "Play/Pause Recording" } },
            { nil, "d", FocusAndSelectMenuItem { "File", "Duplicate" } },
            { nil, "n", FocusAndSelectMenuItem { "File", "Start New Recording" } },
            { nil, "w", FocusAndSelectMenuItem { "File", "Close" } },
            { { "alt" }, "w", FocusAndSelectMenuItem { "File", "Close All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "File", "Rename…" } },
        },
        Edit = {
            { nil, "a", FocusAndSelectMenuItem { "Edit", "Select All" } },
            { nil, "c", FocusAndSelectMenuItem { "Edit", "Copy" } },
            { nil, "f", FocusAndSelectMenuItem { "Edit", "Find…" } },
            { nil, "t", FocusAndSelectMenuItem { "Edit", "Trim Recording" } },
            { nil, "v", FocusAndSelectMenuItem { "Edit", "Paste" } },
            { nil, "x", FocusAndSelectMenuItem { "Edit", "Cut" } },
            { nil, "z", FocusAndSelectMenuItem { "Edit", "Undo" } },
            { { "shift" }, "z", FocusAndSelectMenuItem { "Edit", "Redo" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Edit Recording" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Substitutions" } },
            { unmapped, unmapped, FocusAndChooseMenuItem { "Edit", "Transformations" } },
        },
        View = {
            { { "ctrl" }, "f", FocusAndToggleMenuItem { "Enter Full Screen", "Exit Full Screen" } },
        },
        Window = {
            { nil, "m", FocusAndSelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", FocusAndSelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Voice Memos" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, FocusAndSelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, FocusAndSelectMenuItem { "Help", "Voice Memos Help" } },
        },
    },
}
