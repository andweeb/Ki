----------------------------------------------------------------------------------------------------
-- iTunes application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local previousSong = Application:createMenuItemAction("Previous", { focusAfter = true })
local nextSong = Application:createMenuItemAction("Next", { focusAfter = true })
local stop = Application:createMenuItemAction("Stop", { focusAfter = true })
local goToCurrentSong = Application:createMenuItemAction("Go to Current Song", { focusAfter = true })
local toggleSong = Application:createMenuItemAction({ "Play", "Pause" }, { isToggleable = true })

return Application {
    name = "iTunes",
    shortcuts = {
        { nil, "space", toggleSong, "Play" },
        { nil, "p", previousSong, "Previous" },
        { nil, "n", nextSong, "Next" },
        { nil, "s", stop, "Stop" },
        { nil, "l", goToCurrentSong, "Go to Current Song" },
    },
}
