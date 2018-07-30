local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Maps = Entity:subclass("Maps")

function Maps:initialize(shortcuts)
    Entity.initialize(self, "Maps", shortcuts)
end

return Maps
