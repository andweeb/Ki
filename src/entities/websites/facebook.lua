----------------------------------------------------------------------------------------------------
-- Facebook website config
--
local Website = spoon.Ki.Website

return Website:new("Facebook", "https://facebook.com", {
    { name = "Facebook Messages", link = "/messages" },
    { name = "Facebook Watch", link = "/watch" },
    { name = "Facebook Marketplace", link = "/marketplace" },
    { name = "Facebook Pages", link = "/pages" },
    { name = "Facebook Groups", link = "/groups" },
    { name = "Facebook Events", link = "/events" },
})
