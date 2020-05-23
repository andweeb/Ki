----------------------------------------------------------------------------------------------------
-- Wikipedia website config
--
local Website = spoon.Ki.Website

return Website:new("Wikipedia", "https://wikipedia.org", {
    { name = "Main Page", link = "/wiki/Main_Page" },
    { name = "Featured Contents", link = "/wiki/Portal:Featured_content" },
    { name = "Current Events", link = "/wiki/Portal:Current_events" },
    { name = "Random Article", link = "/wiki/Special:Random" },
})
