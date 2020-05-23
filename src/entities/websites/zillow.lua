----------------------------------------------------------------------------------------------------
-- Zillow website config
--
local Website = spoon.Ki.Website

return Website:new("Zillow", "https://zillow.com", {
    { name = "Buy", link = "/homes/" },
    { name = "Rent", link = "/homes/for_rent/" },
    { name = "Sell", link = "/sell/" },
    { name = "Home Loans", link = "/home-loans/" },
})
