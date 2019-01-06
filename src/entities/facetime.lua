local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {}

function actions.toggle(app)
    _ = app:selectMenuItem("Turn FaceTime Off") or app:selectMenuItem("Turn FaceTime On")
end

local shortcuts = {
    { nil, "space", actions.toggle, { "FaceTime", "Turn FaceTime On or Off" } },
}

return Application:new("FaceTime", shortcuts), shortcuts, actions
