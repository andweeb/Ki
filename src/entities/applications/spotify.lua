----------------------------------------------------------------------------------------------------
-- Spotify application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local search = Application:createMenuItemAction("Search", { focusAfter = true })
local newPlaylist = Application:createMenuItemAction("New Playlist", { focusAfter = true })
local newPlaylistFolder = Application:createMenuItemAction("New Playlist Folder", { focusAfter = true })

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
        Edit = {
            { nil, "l", search, "Search" },
            { { "shift" }, "f", search, "Search" },
        },
        Playback = {
            { nil, "space", togglePlay, "Toggle Play" },
            { nil, "p", playPrevious, "Previous" },
            { nil, "n", playNext, "Next" },
            { nil, "s", stop, "Stop" },
        },
        File = {
            { { "shift" }, "n", newPlaylist, "New Playlist" },
            { { "cmd", "shift" }, "n", newPlaylistFolder, "New Playlist Folder" },
        },
    },
}
