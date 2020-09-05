----------------------------------------------------------------------------------------------------
-- Reddit website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Reddit",
    url = "https://reddit.com",
    links = {
        { name = "Popular", link = "/r/popular" },
        { name = "All", link = "/r/all" },
        { name = "Top Communities", link = "subreddits/leaderboard/" },
        { name = "Reddit Public Access Network", link = "rpan/" },
        { name = "Chat", link = "chat" },
        { name = "Messages", link = "message/inbox" },
        { name = "Settings", link = "settings" },
    },
}
