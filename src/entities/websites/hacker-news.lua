----------------------------------------------------------------------------------------------------
-- Hacker News website config
--
local Website = spoon.Ki.Website

return Website:new("Hacker News", "https://news.ycombinator.com", {
    { name = "New", link = "/newest" },
    { name = "Threads", link = "/threads" },
    { name = "Past", link = "/front" },
    { name = "Comments", link = "/newcomments" },
    { name = "Ask", link = "/ask" },
    { name = "Show", link = "/show" },
    { name = "Jobs", link = "/jobs" },
    { name = "Submit", link = "/submit" },
})
