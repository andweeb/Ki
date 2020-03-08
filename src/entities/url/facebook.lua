----------------------------------------------------------------------------------------------------
-- Facebook URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://facebook.com"
local Facebook = URL:new(baseURL)

Facebook.paths = {
    { name = "Facebook", path = baseURL },
    { name = "Facebook Messages", path = "/messages" },
    { name = "Facebook Watch", path = "/watch" },
    { name = "Facebook Marketplace", path = "/marketplace" },
    { name = "Facebook Pages", path = "/pages" },
    { name = "Facebook Groups", path = "/groups" },
    { name = "Facebook Events", path = "/events" },
}

return Facebook
