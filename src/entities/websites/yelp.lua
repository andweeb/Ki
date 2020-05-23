----------------------------------------------------------------------------------------------------
-- Yelp website config
--
local Website = spoon.Ki.Website

return Website:new("Yelp", "https://yelp.com", {
    { name = "Events", link = "/events" },
    { name = "Talk", link = "/talk" },
    { name = "Mail", link = "/mail" },
})
