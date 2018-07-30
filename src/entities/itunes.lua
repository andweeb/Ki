local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local iTunes = Entity:subclass("iTunes")

function iTunes.togglePlay(app)
    _ = app:selectMenuItem("Play") or app:selectMenuItem("Pause")
end

function iTunes.previous(app)
    app:selectMenuItem("Previous")
end

function iTunes.next(app)
    app:selectMenuItem("Next")
end

function iTunes.stop(app)
    app:selectMenuItem("Stop")
end

function iTunes.goToCurrentSong(app)
    app:selectMenuItem("Go to Current Song")
end

function iTunes:initialize(shortcuts)
    self.autoExitMode = false

    local defaultShortcuts = {
        { nil, "space", self.togglePlay, { "Controls", "Play" } },
        { nil, "p", self.previous, { "Controls", "Previous" } },
        { nil, "n", self.next, { "Controls", "Next" } },
        { nil, "s", self.stop, { "Controls", "Stop" } },
        { nil, "l", self.goToCurrentSong, { "Controls", "Go to Current Song" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "iTunes", shortcuts)
end

return iTunes
