----------------------------------------------------------------------------------------------------
-- Yelp website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Yelp",
    url = "https://yelp.com",
    links = {
        { name = "Events", link = "/events" },
        { name = "Talk", link = "/talk" },
        { name = "Mail", link = "/mail" },
    },
}
