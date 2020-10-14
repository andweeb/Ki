----------------------------------------------------------------------------------------------------
-- FaceTime application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local toggle = Application.createMenuItemEvent({ "Turn FaceTime On", "Turn FaceTime Off" }, {
    isToggleable = true,
    focusBefore = true,
})

return Application {
    name = "FaceTime",
    shortcuts = {
        { nil, "space", toggle, "Turn FaceTime On or Off" },
    },
}
