local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Application = dofile(spoonPath.."/application.lua")
local actions = {}

function actions.toggle(app)
    _ = app:selectMenuItem("Turn FaceTime Off") or app:selectMenuItem("Turn FaceTime On")
end

local shortcuts = {
    { nil, "space", actions.toggle, { "FaceTime", "Turn FaceTime On or Off" } },
}

return Application:new("FaceTime", shortcuts), shortcuts, actions
