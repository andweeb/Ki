----------------------------------------------------------------------------------------------------
-- iTunes application
--
local Application = spoon.Ki.Application
local iTunes = Application:new("iTunes")

local focusAfter = { focusAfter = true }
iTunes.previousSong = Application.createMenuItemEvent("Previous", focusAfter)
iTunes.nextSong = Application.createMenuItemEvent("Next", focusAfter)
iTunes.stop = Application.createMenuItemEvent("Stop", focusAfter)
iTunes.goToCurrentSong = Application.createMenuItemEvent("Go to Current Song", focusAfter)
iTunes.toggleSong = Application.createMenuItemEvent({ "Play", "Pause" }, { isToggleable = true })

iTunes:registerShortcuts({
    { nil, "space", iTunes.toggleSong, { "Controls", "Play" } },
    { nil, "p", iTunes.previousSong, { "Controls", "Previous" } },
    { nil, "n", iTunes.nextSong, { "Controls", "Next" } },
    { nil, "s", iTunes.stop, { "Controls", "Stop" } },
    { nil, "l", iTunes.goToCurrentSong, { "Controls", "Go to Current Song" } },
})

return iTunes
