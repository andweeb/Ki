----------------------------------------------------------------------------------------------------
-- Twitter website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Twitter",
    url = "https://twitter.com",
    links = {
        { name = "Home", link = "/home" },
        { name = "Explore", link = "/explore" },
        { name = "Notifications", link = "/notifications" },
        { name = "Messages", link = "/messages" },
        { name = "Bookmarks", link = "/i/bookmarks" },
    },
}
