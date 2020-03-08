----------------------------------------------------------------------------------------------------
-- Hacker News URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://news.ycombinator.com"
local HackerNews = URL:new(baseURL)

HackerNews.paths = {
    { name = "Hacker News", path = baseURL },
    { name = "New", path = "/newest" },
    { name = "Threads", path = "/threads" },
    { name = "Past", path = "/front" },
    { name = "Comments", path = "/newcomments" },
    { name = "Ask", path = "/ask" },
    { name = "Show", path = "/show" },
    { name = "Jobs", path = "/jobs" },
    { name = "Submit", path = "/submit" },
}

return HackerNews
