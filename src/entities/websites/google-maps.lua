----------------------------------------------------------------------------------------------------
-- Google Maps website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Google Maps",
    url = "https://www.google.com/maps",
    links = {
        { name = "Groceries", link = "/search/Groceries" },
        { name = "Food Delivery", link = "/search/Food+Delivery" },
        { name = "Takeout", link = "/search/Takeout" },
        { name = "Hotels", link = "/search/Hotels" },
    },
}
