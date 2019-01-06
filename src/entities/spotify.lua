local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    search = Application.createMenuItemEvent("Search", { focusAfter = true }),
    newPlaylist = Application.createMenuItemEvent("New Playlist", { focusAfter = true }),
    newPlaylistFolder = Application.createMenuItemEvent("New Playlist Folder", { focusAfter = true }),
}

function actions.togglePlay()
    hs.spotify.playpause()
    return false
end

function actions.playPrevious()
    hs.spotify.previous()
    return false
end

function actions.playNext()
    hs.spotify.next()
    return false
end

function actions.stop()
    hs.spotify.pause()
    return false
end

local shortcuts = {
    { nil, "space", actions.togglePlay, { "Playback", "Toggle Play" } },
    { nil, "p", actions.playPrevious, { "Playback", "Previous" } },
    { nil, "n", actions.playNext, { "Playback", "Next" } },
    { nil, "s", actions.stop, { "Playback", "Stop" } },
    { nil, "l", actions.search, { "Edit", "Search" } },
    { { "cmd" }, "n", actions.newPlaylist, { "File", "New Playlist" } },
    { { "cmd" }, "f", actions.search, { "Edit", "Search" } },
    { { "cmd", "shift" }, "n", actions.newPlaylistFolder, { "File", "New Playlist Folder" } },
}

return Application:new("Spotify", shortcuts), shortcuts, actions
