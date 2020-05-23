----------------------------------------------------------------------------------------------------
-- Amazon website entity
--
local Website = spoon.Ki.Website

return Website:new("Amazon", "https://amazon.com", {
    { name = "Account", link = "/gp/css/homepage.html" },
    { name = "Order History", link = "/gp/css/order-history" },
    { name = "Cart", link = "/gp/cart/view.html" },
    { name = "Today's Deals", link = "/gp/goldbox" },
})
