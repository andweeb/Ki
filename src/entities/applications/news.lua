----------------------------------------------------------------------------------------------------
-- News application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "News",
    shortcuts = {
        News = {
            { nil, ",", SelectMenuItemAndFocus { "News", "Preferences…" } },
            { nil, "h", SelectMenuItemAndFocus { "News", "Hide News" } },
            { nil, "q", SelectMenuItemAndFocus { "News", "Quit News" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "News", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "News", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "News", "About News" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "News", "Clear History" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "News", "Report a Concern…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "News", "Services" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "News", "Show All" } },
        },
        File = {
            { nil, "d", SelectMenuItemAndFocus { "File", "Suggest Fewer Stories Like This" } },
            { nil, "l", SelectMenuItemAndFocus { "File", "Suggest More Stories Like This" } },
            { nil, "s", ToggleMenuItemAndFocus { "Save Story", "Unsave Story" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close" } },
            { { "alt" }, "w", SelectMenuItemAndFocus { "File", "Close All" } },
            { { "shift" }, "d", ToggleMenuItemAndFocus { "Block Channel", "Unblock Channel" } },
            { { "shift" }, "l", ToggleMenuItemAndFocus { "Follow Channel", "Unfollow Channel" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Discover Channels & Topics…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Manage Blocked Channels & Topics…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Manage Notifications & Email…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Manage Subscriptions…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "File", "Open in Safari" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "File", "Share" } },
        },
        Edit = {
            { nil, "a", SelectMenuItemAndFocus { "Edit", "Select All" } },
            { nil, "c", SelectMenuItemAndFocus { "Edit", "Copy" } },
            { nil, "v", SelectMenuItemAndFocus { "Edit", "Paste" } },
            { nil, "x", SelectMenuItemAndFocus { "Edit", "Cut" } },
            { nil, "z", SelectMenuItemAndFocus { "Edit", "Undo" } },
            { { "alt" }, "c", SelectMenuItemAndFocus { "Edit", "Copy Link" } },
            { { "alt" }, "f", SelectMenuItemAndFocus { "Edit", "Search" } },
            { { "shift" }, "z", SelectMenuItemAndFocus { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", SelectMenuItemAndFocus { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Delete" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Speech" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Edit", "Start Dictation" } },
        },
        View = {
            { nil, "+", SelectMenuItemAndFocus { "View", "Zoom In" } },
            { nil, "-", SelectMenuItemAndFocus { "View", "Zoom Out" } },
            { nil, "0", SelectMenuItemAndFocus { "View", "Actual Size" } },
            { nil, "[", SelectMenuItemAndFocus { "View", "Back" } },
            { nil, "r", SelectMenuItemAndFocus { "View", "Check for New Stories" } },
            { nil, "t", ToggleMenuItemAndFocus { "Show Table of Contents", "Hide Table of Contents" } },
            { { "alt" }, "+", SelectMenuItemAndFocus { "View", "Make Text Bigger" } },
            { { "alt" }, "-", SelectMenuItemAndFocus { "View", "Make Text Smaller" } },
            { { "alt" }, "s", ToggleMenuItemAndFocus { "Show Sidebar", "Hide Sidebar" } },
            { { "ctrl" }, "f", ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Customize Toolbar…" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Show Toolbar", "Hide Toolbar" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Next Story" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Previous Story" } },
        },
        Window = {
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { { "alt" }, "m", SelectMenuItemAndFocus { "Window", "Minimize All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Arrange in Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "News" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom All" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "About Apple News & Privacy" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "About Newsletters & Privacy" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "News Help" } },
        },
    },
}
