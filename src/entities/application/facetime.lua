----------------------------------------------------------------------------------------------------
-- FaceTime application
--
local Application = spoon.Ki.Application
local FaceTime = Application:new("FaceTime")

FaceTime.toggle = Application.createMenuItemEvent({ "Turn FaceTime On", "Turn FaceTime Off" }, {
    isToggleable = true,
    focusBefore = true,
})

FaceTime:registerShortcuts({
    { nil, "space", FaceTime.toggle, { "FaceTime", "Turn FaceTime On or Off" } },
})

return FaceTime
