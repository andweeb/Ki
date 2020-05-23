----------------------------------------------------------------------------------------------------
-- YouTube website config
--
local Website = spoon.Ki.Website

return Website:new("YouTube", "https://youtube.com", {
    { name = "Trending", link = "/feed/trending" },
    { name = "Subscriptions", link = "/feed/subscriptions" },
    { name = "Library", link = "/feed/library" },
    { name = "History", link = "/feed/history" },
    { name = "Watch Later", link = "/playlist?list=WL" },
})
