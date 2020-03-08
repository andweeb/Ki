----------------------------------------------------------------------------------------------------
-- Wikipedia URL entity
--
local URL = spoon.Ki.URL
local Wikipedia = URL:new("https://wikipedia.org")

Wikipedia.paths = {
    { name = "Main Page", path = "/wiki/Main_Page" },
    { name = "Featured Contents", path = "/wiki/Portal:Featured_content" },
    { name = "Current Events", path = "/wiki/Portal:Current_events" },
    { name = "Random Article", path = "/wiki/Special:Random" },
}

return Wikipedia
