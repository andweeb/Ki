--- === DefaultEvents ===
---
--- Definitions of default workflow events for default ki modes
---
-- luacov: disable

local DefaultEvents = {}
DefaultEvents.__index = DefaultEvents
DefaultEvents.__name = "default-events"

if not _G.requirePackage then
    function _G.requirePackage(name, isInternal)
        local luaVersion = _VERSION:match("%d+%.%d+")
        local location = not isInternal and "/deps/share/lua/"..luaVersion.."/" or "/"
        local spoonPath = debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
        local packagePath = spoonPath..location..name..".lua"

        return dofile(packagePath)
    end
end

--- DefaultEvents.initEntityEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `entity` and `select` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `entity` workflow events
---  * A list of `select` workflow events
function DefaultEvents.initEntityEvents()
    local ActivityMonitor = _G.requirePackage("entities/activity-monitor", true)
    local AppStore = _G.requirePackage("entities/app-store", true)
    local Calendar = _G.requirePackage("entities/calendar", true)
    local Calculator = _G.requirePackage("entities/calculator", true)
    local Dictionary = _G.requirePackage("entities/dictionary", true)
    local FaceTime = _G.requirePackage("entities/facetime", true)
    local Finder = _G.requirePackage("entities/finder", true)
    local GoogleChrome = _G.requirePackage("entities/google-chrome", true)
    local Home = _G.requirePackage("entities/home", true)
    local iTunes = _G.requirePackage("entities/itunes", true)
    local Maps = _G.requirePackage("entities/maps", true)
    local Mail = _G.requirePackage("entities/mail", true)
    local Messages = _G.requirePackage("entities/messages", true)
    local News = _G.requirePackage("entities/news", true)
    local Notes = _G.requirePackage("entities/notes", true)
    local Preview = _G.requirePackage("entities/preview", true)
    local QuickTimePlayer = _G.requirePackage("entities/quicktime-player", true)
    local Reminders = _G.requirePackage("entities/reminders", true)
    local Safari = _G.requirePackage("entities/Safari", true)
    local Siri = _G.requirePackage("entities/siri", true)
    local Spaces = _G.requirePackage("entities/spaces", true)
    local Spotify = _G.requirePackage("entities/spotify", true)
    local SystemPreferences = _G.requirePackage("entities/system-preferences", true)
    local Terminal = _G.requirePackage("entities/terminal", true)

    local entitySelectEvents = {
        { nil, "g", GoogleChrome:new(), { "Select Events", "Select a Google Chrome tab or window" } },
        { nil, "m", Messages:new(), { "Select Events", "Select a Messages conversation" } },
        { nil, "n", Notes:new(), { "Select Events", "Select a Note" } },
        { nil, "s", Safari:new(), { "Select Events", "Select a Safari tab or window" } },
        { { "alt" }, "s", Spaces:new(), { "Select Events", "Select a Desktop Space" } },
    }

    local entityEvents = {
        { nil, "a", AppStore:new(), { "Entities", "App Store" } },
        { nil, "c", Calendar:new(), { "Entities", "Calendar" } },
        { nil, "d", Dictionary:new(), { "Entities", "Dictionary" } },
        { nil, "f", Finder:new(), { "Entities", "Finder" } },
        { nil, "g", GoogleChrome:new(), { "Entities", "Google Chrome" } },
        { nil, "h", Home:new(), { "Entities", "Home" } },
        { nil, "i", iTunes:new(), { "Entities", "iTunes" } },
        { nil, "m", Messages:new(), { "Entities", "Messages" } },
        { nil, "n", Notes:new(), { "Entities", "Notes" } },
        { nil, "p", Preview:new(), { "Entities", "Preview" } },
        { nil, "q", QuickTimePlayer:new(), { "Entities", "QuickTime Player" } },
        { nil, "r", Reminders:new(), { "Entities", "Reminders" } },
        { nil, "s", Safari:new(), { "Entities", "Safari" } },
        { nil, "t", Terminal:new(), { "Entities", "Terminal" } },
        { nil, ",", SystemPreferences:new(), { "Entities", "System Preferences" } },
        { { "alt" }, "s", Spaces:new(), { "Entities", "Desktop Spaces" } },
        { { "alt", "cmd" }, "s", Siri:new(), { "Entities", "Siri" } },
        { { "shift" }, "a", ActivityMonitor:new(), { "Entities", "Activity Monitor" } },
        { { "shift" }, "c", Calculator:new(), { "Entities", "Calculator" } },
        { { "shift" }, "f", FaceTime:new(), { "Entities", "FaceTime" } },
        { { "shift" }, "m", Maps:new(), { "Entities", "Maps" } },
        { { "shift" }, "n", News:new(), { "Entities", "News" } },
        { { "shift" }, "s", Spotify:new(), { "Entities", "Spotify" } },
        { { "shift", "cmd" }, "m", Mail:new(), { "Entities", "Mail" } },
    }

    return entityEvents, entitySelectEvents
end

function DefaultEvents.initUrlEvents()
    local function urlEventHandler(url)
        return function()
            hs.urlevent.openURL(url)
            return true
        end
    end

    local urlEvents = {
        { nil, "a", urlEventHandler("https://amazon.com"), { "URL Events", "Amazon" } },
        { nil, "f", urlEventHandler("https://facebook.com"), { "URL Events", "Facebook" } },
        { nil, "g", urlEventHandler("https://google.com"), { "URL Events", "Google" } },
        { nil, "h", urlEventHandler("https://news.ycombinator.com"), { "URL Events", "Hacker News" } },
        { nil, "l", urlEventHandler("https://linkedin.com"), { "URL Events", "LinkedIn" } },
        { nil, "m", urlEventHandler("https://messenger.com"), { "URL Events", "Facebook Messenger" } },
        { nil, "n", urlEventHandler("https://netflix.com"), { "URL Events", "Netflix" } },
        { nil, "r", urlEventHandler("https://reddit.com"), { "URL Events", "Reddit" } },
        { nil, "w", urlEventHandler("https://wikipedia.org"), { "URL Events", "Wikipedia" } },
        { nil, "y", urlEventHandler("https://youtube.com"), { "URL Events", "YouTube" } },
        { nil, "z", urlEventHandler("https://zillow.com"), { "URL Events", "Zillow" } },
        { { "shift" }, "g", urlEventHandler("https://github.com"), { "URL Events", "GitHub" } },
        { { "shift" }, "m", urlEventHandler("https://maps.google.com"), { "URL Events", "Google Maps" } },
        { { "shift" }, "w", urlEventHandler("https://weather.com"), { "URL Events", "Weather" } },
        { { "shift" }, "y", urlEventHandler("https://yelp.com"), { "URL Events", "Yelp" } },
        { { "cmd", "shift" }, "m", urlEventHandler("https://mail.google.com"), { "URL Events", "Gmail" } },
    }

    return urlEvents
end

function DefaultEvents.initVolumeEvents()
    local volumeEvents = {
        {
            nil, "j",
            function()
                local newVolume = hs.audiodevice.current().volume - 10
                hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
            end,
            { "Volume Control Mode", "Turn Volume Down" },
        },
        {
            nil, "k",
            function()
                local newVolume = hs.audiodevice.current().volume + 10
                hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
            end,
            { "Volume Control Mode", "Turn Volume Up" },
        },
        {
            nil, "m",
            function()
                local isMuted = hs.audiodevice.defaultOutputDevice():muted()
                hs.audiodevice.defaultOutputDevice():setMuted(isMuted)
                return true
            end,
            { "Volume Control Mode", "Set Volume to Zero" },
        },
        {
            nil, "0",
            function()
                hs.audiodevice.defaultOutputDevice():setVolume(0)
                return true
            end,
            { "Volume Control Mode", "Set Volume to Zero" },
        },
        {
            nil, "1",
            function()
                hs.audiodevice.defaultOutputDevice():setVolume(100)
                return true
            end,
            { "Volume Control Mode", "Set Volume to Max" },
        },
    }

    return volumeEvents
end

function DefaultEvents.initBrightnessEvents()
    local brightnessEvents = {
        {
            nil, "j",
            function()
                local newBrightness = hs.brightness.get() - 10
                hs.brightness.set(newBrightness)
            end,
            { "Brightness Control Mode", "Turn Brightness Down" },
        },
        {
            nil, "k",
            function()
                local newBrightness = hs.brightness.get() + 10
                hs.brightness.set(newBrightness)
            end,
            { "Brightness Control Mode", "Turn Brightness Up" },
        },
        {
            nil, "0",
            function()
                hs.brightness.set(0)
                return true
            end,
            { "Brightness Control Mode", "Set Brightness to Zero" },
        },
        {
            nil, "1",
            function()
                hs.brightness.set(100)
                return true
            end,
            { "Brightness Control Mode", "Set Brightness to Max" },
        },
    }

    return brightnessEvents
end

function DefaultEvents.initNormalEvents()
    local function startScreenSaver()
        hs.osascript.applescript([[
            tell application "System Events"
                start current screen saver
            end tell
        ]])

        return true
    end

    local function toggleDock()
        hs.osascript.applescript([[
            tell application "System Events" to tell dock preferences to set autohide to not autohide
        ]])
    end

    local normalEvents = {
        { nil, "d", toggleDock, { "Normal Mode", "Toggle Dock" } },
        { nil, "s", startScreenSaver, { "Normal Mode", "Start Screen Saver" } },
    }

    return normalEvents
end

--- DefaultEvents.init()
--- Method
--- Defines the initial set of default key bindings and creates the workflow event handlers for default modes
---
--- Parameters:
---  * None
---
--- Returns:
---  * A table containing the default `url`, `entity`, `select`, `volume`, `brightness`, and `normal` workflow events
function DefaultEvents.init()
    local urlEvents = DefaultEvents.initUrlEvents()
    local entityEvents, entitySelectEvents = DefaultEvents.initEntityEvents()
    local volumeEvents = DefaultEvents.initVolumeEvents()
    local brightnessEvents = DefaultEvents.initBrightnessEvents()
    local normalEvents = DefaultEvents.initNormalEvents()

    return {
        url = urlEvents,
        select = entitySelectEvents,
        entity = entityEvents,
        volume = volumeEvents,
        brightness = brightnessEvents,
        normal = normalEvents,
    }
end

return DefaultEvents
