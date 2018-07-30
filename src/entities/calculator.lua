local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Calculator = Entity:subclass("Calculator")

function Calculator:initialize(shortcuts)
    Entity.initialize(self, "Calculator", shortcuts)
end

return Calculator
