local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Application = dofile(spoonPath.."/application.lua")
local actions = {}

function actions.activateSiri()
    hs.application.open("Siri")
end

local shortcuts = {
    { nil, nil, actions.activateSiri, { "Siri", "Activate Siri" } },
}

return Application:new("Siri", shortcuts), shortcuts, actions
