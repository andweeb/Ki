local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Finder = Entity:subclass("Finder")

function Finder:initialize(shortcuts)
    Entity.initialize(self, "Finder", shortcuts)
end

return Finder
