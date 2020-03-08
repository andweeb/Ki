----------------------------------------------------------------------------------------------------
-- Amazon URL entity
--
local URL = spoon.Ki.URL
local Amazon = URL:new("https://amazon.com")

Amazon.paths = {
    { name = "Account", path = "/gp/css/homepage.html" },
    { name = "Order History", path = "/gp/css/order-history" },
    { name = "Cart", path = "/gp/cart/view.html" },
    { name = "Today's Deals", path = "/gp/goldbox" },
}

return Amazon
