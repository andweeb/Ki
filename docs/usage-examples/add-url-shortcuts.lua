-- Example `init.lua` file that adds some custom URL shortcuts

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Create some event handlers to open URLs
local openKiGithubURL = function() return hs.urlevent.openURL("https://github.com/andweeb/ki") end
local openHammerspoonURL = function() return hs.urlevent.openURL("http://www.hammerspoon.org") end

-- Define url shortcuts
local urlWorkflows = {
    { nil, "k", openKiGithubURL, { "URL Events", "Ki Github Page" } },
    { { "shift" }, "h", openHammerspoonURL, { "URL Events", "Hammerspoon Website" } },
}

-- Set custom URL mode workflows
spoon.Ki.workflows = {
    url = urlWorkflows,
}

-- Start Ki
spoon.Ki:start()
