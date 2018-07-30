local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local News = Entity:subclass("News")

function News:initialize(shortcuts)
    Entity.initialize(self, "News", shortcuts)
end

return News
