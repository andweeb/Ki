----------------------------------------------------------------------------------------------------
-- Reddit URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://reddit.com"
local Reddit = URL:new(baseURL)

Reddit.paths = {
    { name = "Home", path = baseURL },
    { name = "Popular", path = "/r/popular" },
    { name = "All", path = "/r/all" },
    { name = "Top Communities", path = "subreddits/leaderboard/" },
    { name = "Reddit Public Access Network", path = "rpan/" },
    { name = "Chat", path = "chat" },
    { name = "Messages", path = "message/inbox" },
    { name = "Settings", path = "settings" },
}

return Reddit
