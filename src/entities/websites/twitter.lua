----------------------------------------------------------------------------------------------------
-- Twitter website config
--
local Website = spoon.Ki.Website

return Website:new("Twitter", "https://twitter.com", {
    { name = "Home", link = "/home" },
    { name = "Explore", link = "/explore" },
    { name = "Notifications", link = "/notifications" },
    { name = "Messages", link = "/messages" },
    { name = "Bookmarks", link = "/i/bookmarks" },
})
