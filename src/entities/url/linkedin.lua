----------------------------------------------------------------------------------------------------
-- LinkedIn URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://linkedin.com"
local LinkedIn = URL:new(baseURL)

LinkedIn.paths = {
    { name = "LinkedIn", path = baseURL },
    { name = "My Network", path = "/mynetwork/" },
    { name = "Jobs", path = "/jobs/" },
    { name = "Messaging", path = "/messaging/" },
    { name = "Notifications", path = "/notifications/" },
}

return LinkedIn
