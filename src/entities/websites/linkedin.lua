----------------------------------------------------------------------------------------------------
-- LinkedIn website config
--
local Website = spoon.Ki.Website

return Website:new("LinkedIn", "https://linkedin.com", {
    { name = "My Feed", link = "/feed/" },
    { name = "My Network", link = "/mynetwork/" },
    { name = "Jobs", link = "/jobs/" },
    { name = "Messaging", link = "/messaging/" },
    { name = "Notifications", link = "/notifications/" },
})
