----------------------------------------------------------------------------------------------------
-- Amazon website entity
--
local Ki = spoon.Ki
local Website = Ki.Website

return Website {
    name = "Amazon",
    url = "https://amazon.com",
    links = {
        { name = "Account", link = "/gp/css/homepage.html" },
        { name = "Order History", link = "/gp/css/order-history" },
        { name = "Cart", link = "/gp/cart/view.html" },
        { name = "Today's Deals", link = "/gp/goldbox" },
    },
}
