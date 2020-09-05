----------------------------------------------------------------------------------------------------
-- Hacker News website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Hacker News",
    url = "https://news.ycombinator.com",
    links = {
        { name = "New", link = "/newest" },
        { name = "Threads", link = "/threads" },
        { name = "Past", link = "/front" },
        { name = "Comments", link = "/newcomments" },
        { name = "Ask", link = "/ask" },
        { name = "Show", link = "/show" },
        { name = "Jobs", link = "/jobs" },
        { name = "Submit", link = "/submit" },
    },
}
