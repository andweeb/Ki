-- Example `init.lua` file that creates a custom scroll mode
-- with navigational `hjkl`, `C-d`, and `C-u` hotkeys

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Set state events to enable transitions for scroll mode.
-- Expose `enterScrollMode` in the FSM to allow transition from normal mode to scroll mode,
-- and `exitMode` to exit from scroll mode back to desktop mode.
spoon.Ki.stateEvents = {
    { name = "enterScrollMode", from = "normal", to = "scroll" },
    { name = "exitMode", from = "scroll", to = "desktop" },
}

-- Set custom scroll mode transition events.
spoon.Ki.transitions = {
    -- Add normal mode transition event to enter scroll mode with cmd+ctrl+s from normal mode
    normal = {
        {
            {"cmd", "shift"}, "s",
            function() spoon.Ki.state:enterScrollMode() end,
            { "Normal Mode", "Transition to Scroll Mode" },
        },
    },
    -- Add scroll mode transition event to exit scroll mode with escape back to desktop mode.
    scroll = {
        {
            nil, "escape",
            function() spoon.Ki.state:exitMode() end,
            { "Scroll Mode", "Exit to Desktop Mode" },
        },
    }
}

-- Scroll event handler helper method
local function createScrollEvent(offsets)
    return function()
        hs.eventtap.event.newScrollEvent(offsets, {}, 'pixel'):post()
    end
end

-- Define custom scroll mode shortcuts
local scrollWorkflows = {
    { nil, "h", createScrollEvent({ 50, 0 }), { "Scroll Events", "Scroll Left" } },
    { nil, "k", createScrollEvent({ 0, 50 }), { "Scroll Events", "Scroll Up" } },
    { nil, "j", createScrollEvent({ 0, -50 }), { "Scroll Events", "Scroll Down" } },
    { nil, "l", createScrollEvent({ -50, 0 }), { "Scroll Events", "Scroll Right" } },
    { { "ctrl" }, "d", createScrollEvent({ 0, -500 }), { "Scroll Events", "Scroll Half Page Down" } },
    { { "ctrl" }, "u", createScrollEvent({ 0, 500 }), { "Scroll Events", "Scroll Half Page Up" } },
}

-- Set custom workflows
spoon.Ki.workflows = {
    scroll = scrollWorkflows,
}

-- Start Ki
spoon.Ki:start()
