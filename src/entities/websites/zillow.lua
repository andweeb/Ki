----------------------------------------------------------------------------------------------------
-- Zillow website config
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Zillow",
    url = "https://zillow.com",
    links = {
        { "Buy", "/homes/" },
        { "Rent", "/homes/for_rent/" },
        { "Sell", "/sell/" },
        { "Home Loans", "/home-loans/" },
    },
}
