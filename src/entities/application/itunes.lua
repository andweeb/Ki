----------------------------------------------------------------------------------------------------
-- iTunes application
--
local Application = spoon.Ki.Application
local iTunes = Application:new("iTunes")

-- Initialize menu item events
iTunes.previousSong = Application.createMenuItemEvent("Previous", { focusAfter = true })
iTunes.nextSong = Application.createMenuItemEvent("Next", { focusAfter = true })
iTunes.stop = Application.createMenuItemEvent("Stop", { focusAfter = true })
iTunes.goToCurrentSong = Application.createMenuItemEvent("Go to Current Song", { focusAfter = true })
iTunes.toggleSong = Application.createMenuItemEvent({ "Play", "Pause" }, { isToggleable = true })

iTunes:registerShortcuts({
    { nil, "space", iTunes.toggleSong, { "Controls", "Play" } },
    { nil, "p", iTunes.previousSong, { "Controls", "Previous" } },
    { nil, "n", iTunes.nextSong, { "Controls", "Next" } },
    { nil, "s", iTunes.stop, { "Controls", "Stop" } },
    { nil, "l", iTunes.goToCurrentSong, { "Controls", "Go to Current Song" } },
})

return iTunes
