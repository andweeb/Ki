----------------------------------------------------------------------------------------------------
-- YouTube website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "YouTube",
    url = "https://youtube.com",
    links = {
        { name = "Trending", link = "/feed/trending" },
        { name = "Subscriptions", link = "/feed/subscriptions" },
        { name = "Library", link = "/feed/library" },
        { name = "History", link = "/feed/history" },
        { name = "Watch Later", link = "/playlist?list=WL" },
    },
}
