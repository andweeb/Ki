local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {}

function actions.activateSiri()
    hs.application.open("Siri")
end

local shortcuts = {
    { nil, nil, actions.activateSiri, { "Siri", "Activate Siri" } },
}

return Application:new("Siri", shortcuts), shortcuts, actions
