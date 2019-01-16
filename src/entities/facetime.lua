local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    toggle = Application.createMenuItemEvent({ "Turn FaceTime On", "Turn FaceTime Off" }, {
        isToggleable = true,
        focusBefore = true,
    }),
}

local shortcuts = {
    { nil, "space", actions.toggle, { "FaceTime", "Turn FaceTime On or Off" } },
}

return Application:new("FaceTime", shortcuts), shortcuts, actions
