----------------------------------------------------------------------------------------------------
-- Facebook website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Facebook",
    url = "https://facebook.com",
    links = {
        { name = "Facebook Messages", link = "/messages" },
        { name = "Facebook Watch", link = "/watch" },
        { name = "Facebook Marketplace", link = "/marketplace" },
        { name = "Facebook Pages", link = "/pages" },
        { name = "Facebook Groups", link = "/groups" },
        { name = "Facebook Events", link = "/events" },
    },
}
