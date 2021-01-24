----------------------------------------------------------------------------------------------------
-- Disk Utility application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "Disk Utility",
    shortcuts = {
        ["Disk Utility"] = {
            { nil, "h", SelectMenuItemAndFocus { "Disk Utility", "Hide Disk Utility" } },
            { nil, "q", SelectMenuItemAndFocus { "Disk Utility", "Quit Disk Utility" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "Disk Utility", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "Disk Utility", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Disk Utility", "About Disk Utility" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Disk Utility", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Disk Utility", "Show All" } },
        },
        File = {
            { nil, "e", SelectMenuItemAndFocus { "File", "Eject" } },
            { nil, "i", SelectMenuItemAndFocus { "File", "Get Info" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close" } },
            { { "alt" }, "o", SelectMenuItemAndFocus { "File", "Open Disk Image…" } },
            { { "alt" }, "w", SelectMenuItemAndFocus { "File", "Close All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Change Password..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Enable Journaling" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "New Image" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "RAID Assistant..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Rename" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Run First Aid..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Show in Finder" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Unmount" } },
        },
        Edit = {
            { nil, "a", SelectMenuItemAndFocus { "Edit", "Select All" } },
            { nil, "c", SelectMenuItemAndFocus { "Edit", "Copy" } },
            { nil, "v", SelectMenuItemAndFocus { "Edit", "Paste" } },
            { nil, "x", SelectMenuItemAndFocus { "Edit", "Cut" } },
            { nil, "z", SelectMenuItemAndFocus { "Edit", "Undo" } },
            { { "shift" }, "e", SelectMenuItemAndFocus { "Edit", "Erase..." } },
            { { "shift" }, "p", SelectMenuItemAndFocus { "Edit", "Partition..." } },
            { { "shift" }, "r", SelectMenuItemAndFocus { "Edit", "Restore..." } },
            { { "shift" }, "z", SelectMenuItemAndFocus { "Edit", "Redo" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Add APFS Volume…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Convert to APFS…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Delete APFS Volume…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Delete" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Find" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Speech" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Start Dictation" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Substitutions" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Transformations" } },
        },
        Images = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Images", "Add Checksum..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Images", "Convert..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Images", "Resize..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Images", "Scan Image For Restore..." } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Images", "Verify..." } },
        },
        View = {
            { nil, "1", SelectMenuItemAndFocus { "View", "Show Only Volumes" } },
            { nil, "2", SelectMenuItemAndFocus { "View", "Show All Devices" } },
            { { "alt" }, "s", SelectMenuItemAndFocus { "View", "Hide Sidebar" } },
            { { "alt" }, "t", SelectMenuItemAndFocus { "View", "Show Toolbar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Customize Toolbar…" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
        },
        Window = {
            { nil, "d", SelectMenuItemAndFocus { "Window", "Disk Utility" } },
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { { "alt" }, "m", SelectMenuItemAndFocus { "Window", "Minimize All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Arrange in Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Disk Utility" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Right Side of Screen" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Disk Utility Help" } },
        },
    },
}
