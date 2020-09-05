----------------------------------------------------------------------------------------------------
-- LinkedIn website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "LinkedIn",
    url = "https://linkedin.com",
    links = {
        { name = "My Feed", link = "/feed/" },
        { name = "My Network", link = "/mynetwork/" },
        { name = "Jobs", link = "/jobs/" },
        { name = "Messaging", link = "/messaging/" },
        { name = "Notifications", link = "/notifications/" },
    },
}
