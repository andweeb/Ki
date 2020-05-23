----------------------------------------------------------------------------------------------------
-- Reddit website config
--
local Website = spoon.Ki.Website

return Website:new("Reddit", "https://reddit.com", {
    { name = "Popular", link = "/r/popular" },
    { name = "All", link = "/r/all" },
    { name = "Top Communities", link = "subreddits/leaderboard/" },
    { name = "Reddit Public Access Network", link = "rpan/" },
    { name = "Chat", link = "chat" },
    { name = "Messages", link = "message/inbox" },
    { name = "Settings", link = "settings" },
})
