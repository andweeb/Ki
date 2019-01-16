-- Example `init.lua` file that adds a custom hotkey to enter normal mode

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Set custom transition event that enters normal mode.
spoon.Ki.transitionEvents = {
    -- Add desktop mode transition event to enter normal mode with cmd+; from desktop mode
    desktop = {
        {
            {"cmd"}, ";",
            function() spoon.Ki.state:enterNormalMode() end,
            { "Desktop Mode", "Transition to Normal Mode" },
        },
    },
}

-- Start Ki
spoon.Ki:start()
