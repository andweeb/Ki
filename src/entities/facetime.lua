local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local FaceTime = Entity:subclass("FaceTime")

function FaceTime.toggle(app)
    _ = app:selectMenuItem("Turn FaceTime Off") or app:selectMenuItem("Turn FaceTime On")
end

function FaceTime:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "space", self.toggle, { self.name, "Turn FaceTime On or Off" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "FaceTime", shortcuts)
end

return FaceTime
