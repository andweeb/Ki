-- Example `init.lua` file that creates a new custom application entity
-- that implements custom actions specific to the application

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Create and initialize a new VLC Ki application
local Application = spoon.Ki.Application

-- Helper method to create event handlers that execute some applescript
local function executeApplescriptEvent(script)
    return function()
        return hs.osascript.applescript(script)
    end
end

-- Define VLC-specific actions that control media playback
local vlcActions = {
    openFile = Application.createMenuItemEvent("Open File..."),
    playPause = executeApplescriptEvent([[ tell application "VLC" to play ]]),
    stop = executeApplescriptEvent([[ tell application "VLC" to stop ]]),
}

-- Define the shortcut keybindings corresponding to each action
local vlcShortcuts = {
    { nil, "space", vlcActions.playPause, { "Playback", "Toggle Play" } },
    { nil, "o", vlcActions.openFile, { "File", "Open File" } },
    { nil, "s", vlcActions.stop, { "Playback", "Stop" } },
}

-- Initialize the application with the custom shortcuts
local VLC = Application:new("VLC", vlcShortcuts)

-- Define the VLC workflow events
local entityWorkflows = {
    { nil, "v", VLC, { "Entities", "VLC Media Player" } },
}

local selectEntityWorkflows = {
    { nil, "v", VLC, { "Entities", "Select VLC Windows" } },
}

-- Set custom workflows
spoon.Ki.workflows = {
    entity = entityWorkflows,
    select = selectEntityWorkflows,
}

-- Start Ki
spoon.Ki:start()
