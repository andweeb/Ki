----------------------------------------------------------------------------------------------------
-- Google Maps website config
--
local Website = spoon.Ki.Website

return Website:new("Google Maps", "https://www.google.com/maps", {
    { name = "Groceries", link = "/search/Groceries" },
    { name = "Food Delivery", link = "/search/Food+Delivery" },
    { name = "Takeout", link = "/search/Takeout" },
    { name = "Hotels", link = "/search/Hotels" },
})
