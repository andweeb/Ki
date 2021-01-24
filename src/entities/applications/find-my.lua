----------------------------------------------------------------------------------------------------
-- Find My application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "Find My",
    shortcuts = {
        ["Find My"] = {
            { nil, "h", SelectMenuItemAndFocus { "Find My", "Hide Find My" } },
            { nil, "q", SelectMenuItemAndFocus { "Find My", "Quit Find My" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "Find My", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "Find My", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Find My", "About Find My" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Find My", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Find My", "Show All" } },
        },
        File = {
            { nil, "w", SelectMenuItemAndFocus { "File", "Close" } },
            { { "alt" }, "w", SelectMenuItemAndFocus { "File", "Close All" } },
        },
        Edit = {
            { nil, "a", SelectMenuItemAndFocus { "Edit", "Select All" } },
            { nil, "c", SelectMenuItemAndFocus { "Edit", "Copy" } },
            { nil, "f", SelectMenuItemAndFocus { "Edit", "Find…" } },
            { nil, "v", SelectMenuItemAndFocus { "Edit", "Paste" } },
            { nil, "x", SelectMenuItemAndFocus { "Edit", "Cut" } },
            { nil, "z", SelectMenuItemAndFocus { "Edit", "Undo" } },
            { { "shift" }, "z", SelectMenuItemAndFocus { "Edit", "Redo" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Delete" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Speech" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Start Dictation" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Substitutions" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Transformations" } },
        },
        View = {
            { nil, "+", SelectMenuItemAndFocus { "View", "Zoom In" } },
            { nil, "-", SelectMenuItemAndFocus { "View", "Zoom Out" } },
            { nil, "1", SelectMenuItemAndFocus { "View", "People" } },
            { nil, "2", SelectMenuItemAndFocus { "View", "Devices" } },
            { { "ctrl" }, "f", ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
            { { "shift" }, "l", SelectMenuItemAndFocus { "View", "Share My Location" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "View", "Distance" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Maps" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "View", "View" } },
        },
        Window = {
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { { "alt" }, "m", SelectMenuItemAndFocus { "Window", "Minimize All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Arrange in Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Find My" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Find My Help" } },
        },
    },
}
