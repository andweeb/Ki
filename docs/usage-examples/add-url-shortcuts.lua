-- Example `init.lua` file that adds some custom URL shortcuts

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

local function openURLEvent(url)
    return function()
        return hs.urlevent.openURL(url)
    end
end

-- Define url shortcuts
local urlEvents = {
    { nil, "k", openURLEvent("https://github.com/andweeb/ki"), { "URL Events", "Ki Github Page" } },
    { { "shift" }, "h", openURLEvent("http://www.hammerspoon.org"), { "URL Events", "Hammerspoon Website" } },
}

-- Set custom URL mode workflow events
spoon.Ki.workflowEvents = {
    url = urlEvents,
}

-- Start Ki
spoon.Ki:start()
