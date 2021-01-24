----------------------------------------------------------------------------------------------------
-- Calculator application config
--
local Ki = spoon.Ki
local Application = Ki.Application
local ChooseMenuItemAndFocus = Application.ChooseMenuItemAndFocus
local SelectMenuItemAndFocus = Application.SelectMenuItemAndFocus
local ToggleMenuItemAndFocus = Application.ToggleMenuItemAndFocus
local unmapped = Application.unmapped

return Application {
    name = "Calculator",
    shortcuts = {
        Calculator = {
            { nil, "h", SelectMenuItemAndFocus { "Calculator", "Hide Calculator" } },
            { nil, "q", SelectMenuItemAndFocus { "Calculator", "Quit Calculator" } },
            { { "alt" }, "h", SelectMenuItemAndFocus { "Calculator", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItemAndFocus { "Calculator", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Calculator", "About Calculator" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Calculator", "Show All" } },
        },
        File = {
            { nil, "p", SelectMenuItemAndFocus { "File", "Print Tape…" } },
            { nil, "w", SelectMenuItemAndFocus { "File", "Close" } },
            { { "alt" }, "w", SelectMenuItemAndFocus { "File", "Close All" } },
            { { "shift" }, "p", SelectMenuItemAndFocus { "File", "Page Setup…" } },
            { { "shift" }, "s", SelectMenuItemAndFocus { "File", "Save Tape As…" } },
        },
        View = {
            { nil, "1", SelectMenuItemAndFocus { "View", "Basic" } },
            { nil, "2", SelectMenuItemAndFocus { "View", "Scientific" } },
            { nil, "3", SelectMenuItemAndFocus { "View", "Programmer" } },
            { nil, "r", SelectMenuItemAndFocus { "View", "RPN Mode" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "View", "Decimal Places" } },
            { unmapped, unmapped, ToggleMenuItemAndFocus { "Enter Full Screen", "Exit Full Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "View", "Show Thousands Separators" } },
        },
        Convert = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Area…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Currency…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Energy or Work…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Length…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Power…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Pressure…" } },
            { unmapped, unmapped, ChooseMenuItemAndFocus { "Convert", "Recent Conversions" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Speed…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Temperature…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Time…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Volume…" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Convert", "Weights and Masses…" } },
        },
        Speech = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Speech", "Speak Button Pressed" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Speech", "Speak Result" } },
        },
        Window = {
            { nil, "m", SelectMenuItemAndFocus { "Window", "Minimize" } },
            { nil, "t", ToggleMenuItemAndFocus { "Show Paper Tape", "Hide Paper Tape" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, SelectMenuItemAndFocus { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItemAndFocus { "Help", "Calculator Help" } },
        },
    },
}
