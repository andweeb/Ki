----------------------------------------------------------------------------------------------------
-- Twitter URL entity
--
local URL = spoon.Ki.URL
local Twitter = URL:new("https://twitter.com")

Twitter.paths = {
    { name = "Home", path = "/home" },
    { name = "Explore", path = "/explore" },
    { name = "Notifications", path = "/notifications" },
    { name = "Messages", path = "/messages" },
    { name = "Bookmarks", path = "/i/bookmarks" },
}

return Twitter
