----------------------------------------------------------------------------------------------------
-- iTunes application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local previousSong = Application.createMenuItemEvent("Previous", { focusAfter = true })
local nextSong = Application.createMenuItemEvent("Next", { focusAfter = true })
local stop = Application.createMenuItemEvent("Stop", { focusAfter = true })
local goToCurrentSong = Application.createMenuItemEvent("Go to Current Song", { focusAfter = true })
local toggleSong = Application.createMenuItemEvent({ "Play", "Pause" }, { isToggleable = true })

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
