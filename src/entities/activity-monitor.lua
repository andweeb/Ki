local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local ActivityMonitor = Entity:subclass("ActivityMonitor")

function ActivityMonitor:initialize(shortcuts)
    Entity.initialize(self, "Activity Monitor", shortcuts)
end

return ActivityMonitor
