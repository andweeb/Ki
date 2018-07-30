local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local AppStore = Entity:subclass("AppStore")

function AppStore:initialize(shortcuts)
    Entity.initialize(self, "App Store", shortcuts)
end

return AppStore
