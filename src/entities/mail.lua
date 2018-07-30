local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Mail = Entity:subclass("Mail")

function Mail:initialize(shortcuts)
    Entity.initialize(self, "Mail", shortcuts)
end

return Mail
