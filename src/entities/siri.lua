local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Siri = Entity:subclass("Siri")

function Siri:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, nil, function() hs.application.open("Siri") end, { self.name, "Activate Siri" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Siri", shortcuts)
end

return Siri
