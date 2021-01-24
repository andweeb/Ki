----------------------------------------------------------------------------------------------------
-- TextEdit application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "TextEdit",
    shortcuts = {
        TextEdit = {
            { nil, ",", SelectMenuItemAndFocus { "TextEdit", "Preferences…" } },
            { nil, "h", SelectMenuItemAndFocus { "TextEdit", "Hide TextEdit" } },
            { nil, "q", SelectMenuItemAndFocus { "TextEdit", "Quit TextEdit" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "TextEdit", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "TextEdit", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "TextEdit", "About TextEdit" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "TextEdit", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "TextEdit", "Show All" } },
        },
        File = {
            { nil, "n", SelectMenuItemAndFocus { "File", "New" } },
            { nil, "o", SelectMenuItemAndFocus { "File", "Open…" } },
            { nil, "p", SelectMenuItemAndFocus { "File", "Print…" } },
            { nil, "s", SelectMenuItemAndFocus { "File", "Save…" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close" } },
            { { "alt" }, "p", ToggleMenuItemAndFocus { "Show Properties", "Hide Properties" } },
            { { "alt" }, "w", SelectMenuItemAndFocus { "File", "Close All" } },
            { { "shift" }, "p", SelectMenuItemAndFocus { "File", "Page Setup…" } },
            { { "shift" }, "s", SelectMenuItemAndFocus { "File", "Duplicate" } },
            { { "shift", "alt" }, "s", SelectMenuItemAndFocus { "File", "Save As…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Export as PDF…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Insert from iPhone" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Move To…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Open Recent" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Rename…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Revert To" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Share" } },
        },
        Edit = {
            { nil, "a", SelectMenuItemAndFocus { "Edit", "Select All" } },
            { nil, "c", SelectMenuItemAndFocus { "Edit", "Copy" } },
            { nil, "k", SelectMenuItemAndFocus { "Edit", "Add Link…" } },
            { nil, "v", SelectMenuItemAndFocus { "Edit", "Paste" } },
            { nil, "x", SelectMenuItemAndFocus { "Edit", "Cut" } },
            { nil, "z", SelectMenuItemAndFocus { "Edit", "Undo" } },
            { { "shift" }, "a", SelectMenuItemAndFocus { "Edit", "Attach Files…" } },
            { { "shift" }, "z", SelectMenuItemAndFocus { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", SelectMenuItemAndFocus { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Complete" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Delete" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Find" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Insert" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Speech" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Start Dictation" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Substitutions" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Transformations" } },
        },
        Format = {
            { { "shift" }, "t", ToggleMenuItemAndFocus { "Make Plain Text", "Make Rich Text" } },
            { { "shift" }, "w", ToggleMenuItemAndFocus { "Wrap to Page", "Wrap to Window" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Allow Hyphenation", "Do not Allow Hyphenation" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Format", "Font" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Format", "List…" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Make Layout Horizontal", "Make Layout Vertical" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Prevent Editing", "Allow Editing" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Format", "Table…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Format", "Text" } },
        },
        View = {
            { nil, "0", SelectMenuItemAndFocus { "View", "Actual Size" } },
            { { "ctrl" }, "f", ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, ",", SelectMenuItemAndFocus { "View", "Zoom Out" } },
            { { "shift" }, ".", SelectMenuItemAndFocus { "View", "Zoom In" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Show All Tabs", "Exit Tab Overview" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Show Tab Bar", "Hide Tab Bar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Use Dark Background for Windows" } },
        },
        Window = {
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { { "alt" }, "m", SelectMenuItemAndFocus { "Window", "Minimize All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Arrange in Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Merge All Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Tab to New Window" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Show Next Tab" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Show Previous Tab" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Untitled" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "TextEdit Help" } },
        },
    },
}
