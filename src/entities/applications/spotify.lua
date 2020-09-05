----------------------------------------------------------------------------------------------------
-- Spotify application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local search = Application.createMenuItemEvent("Search", { focusAfter = true })
local newPlaylist = Application.createMenuItemEvent("New Playlist", { focusAfter = true })
local newPlaylistFolder = Application.createMenuItemEvent("New Playlist Folder", { focusAfter = true })

-- Action to play or pause the current song
local function togglePlay()
    hs.spotify.playpause()
    return false
end

-- Action to play the previous song
local function playPrevious()
    hs.spotify.previous()
    return false
end

-- Action to play the next song
local function playNext()
    hs.spotify.next()
    return false
end

-- Action to stop the currently playing song
local function stop()
    hs.spotify.pause()
    return false
end

return Application {
    name = "Spotify",
    shortcuts = {
        { nil, "space", togglePlay, { "Playback", "Toggle Play" } },
        { nil, "p", playPrevious, { "Playback", "Previous" } },
        { nil, "n", playNext, { "Playback", "Next" } },
        { nil, "s", stop, { "Playback", "Stop" } },
        { nil, "l", search, { "Edit", "Search" } },
        { { "shift" }, "n", newPlaylist, { "File", "New Playlist" } },
        { { "shift" }, "f", search, { "Edit", "Search" } },
        { { "cmd", "shift" }, "n", newPlaylistFolder, { "File", "New Playlist Folder" } },
    },
}
