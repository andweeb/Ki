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
        { nil, "space", toggleSong, { "Controls", "Play" } },
        { nil, "p", previousSong, { "Controls", "Previous" } },
        { nil, "n", nextSong, { "Controls", "Next" } },
        { nil, "s", stop, { "Controls", "Stop" } },
        { nil, "l", goToCurrentSong, { "Controls", "Go to Current Song" } },
    },
}
