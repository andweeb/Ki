local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    previousSong = Application.createMenuItemEvent("Previous", { focusAfter = true }),
    nextSong = Application.createMenuItemEvent("Next", { focusAfter = true }),
    stop = Application.createMenuItemEvent("Stop", { focusAfter = true }),
    goToCurrentSong = Application.createMenuItemEvent("Go to Current Song", { focusAfter = true }),
    toggleSong = Application.createMenuItemEvent({ "Play", "Pause" }, { isToggleable = true }),
}

local shortcuts = {
    { nil, "space", actions.toggleSong, { "Controls", "Play" } },
    { nil, "p", actions.previousSong, { "Controls", "Previous" } },
    { nil, "n", actions.nextSong, { "Controls", "Next" } },
    { nil, "s", actions.stop, { "Controls", "Stop" } },
    { nil, "l", actions.goToCurrentSong, { "Controls", "Go to Current Song" } },
}

return Application:new("iTunes", shortcuts), shortcuts, actions
