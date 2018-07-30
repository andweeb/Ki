local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Home = Entity:subclass("Home")

function Home:initialize(shortcuts)
    Entity.initialize(self, "Home", shortcuts)
end

return Home
