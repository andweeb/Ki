----------------------------------------------------------------------------------------------------
-- YouTube URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://youtube.com"
local YouTube = URL:new(baseURL)

YouTube.paths = {
    { name = "YouTube", path = baseURL },
    { name = "Trending", path = "/feed/trending" },
    { name = "Subscriptions", path = "/feed/subscriptions" },
    { name = "Library", path = "/feed/library" },
    { name = "History", path = "/feed/history" },
    { name = "Watch Later", path = "/playlist?list=WL" },
}

return YouTube
