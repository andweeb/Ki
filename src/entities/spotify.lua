local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Spotify = Entity:subclass("Spotify")

function Spotify.togglePlay()
    hs.spotify.playpause()
    return false
end

function Spotify.playPrevious()
    hs.spotify.previous()
    return false
end

function Spotify.playNext()
    hs.spotify.next()
    return false
end

function Spotify.stop()
    hs.spotify.pause()
    return false
end

function Spotify.openLocation(app)
    app:selectMenuItem("Search")
end

function Spotify:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "space", self.togglePlay, { "Playback", "Toggle Play" } },
        { nil, "p", self.playPrevious, { "Playback", "Previous" } },
        { nil, "n", self.playNext, { "Playback", "Next" } },
        { nil, "s", self.stop, { "Playback", "Stop" } },
        { nil, "l", self.openLocation, { "Edit", "Search" } },
        { { "cmd" }, "n", self.playNext, { "File", "New Playlist" } },
        { { "cmd" }, "f", self.openLocation, { "Edit", "Search" } },
        { { "cmd", "shift" }, "n", self.playNext, { "File", "New Playlist Folder" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Spotify", shortcuts)
end

return Spotify
