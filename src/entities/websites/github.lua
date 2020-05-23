----------------------------------------------------------------------------------------------------
-- GitHub website config
--
local Website = spoon.Ki.Website

return Website:new("GitHub", "https://github.com", {
    -- Main routes
    { name = "Pull Requests", link = "/pulls" },
    { name = "Issues", link = "/issues" },
    { name = "Marketplace", link = "/marketplace" },
    { name = "Explore", link = "/explore" },
    { name = "Notifications", link = "/notifications" },
    -- Profile
    { name = "Gists", link = "https://gist.github.com/mine" },
    { name = "Settings", link = "/settings/profile" },
    { name = "Help", link = "https://help.github.com/" },
    -- "Create New" Actions
    { name = "New repository", link = "/new" },
    { name = "Import repository", link = "/new/import" },
    { name = "New gist", link = "https://gist.github.com/" },
    { name = "New organization", link = "/organizations/new" },
    { name = "New project", link = "/new/project" },
})
