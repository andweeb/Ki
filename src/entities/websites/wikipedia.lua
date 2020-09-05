----------------------------------------------------------------------------------------------------
-- Wikipedia website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Wikipedia",
    url = "https://wikipedia.org",
    links = {
        { name = "Main Page", link = "/wiki/Main_Page" },
        { name = "Featured Contents", link = "/wiki/Portal:Featured_content" },
        { name = "Current Events", link = "/wiki/Portal:Current_events" },
        { name = "Random Article", link = "/wiki/Special:Random" },
    },
}
