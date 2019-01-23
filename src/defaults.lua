--- === Defaults ===
---
--- Definitions of default events and entities
---
-- luacov: disable

local Defaults = {}
Defaults.__index = Defaults
Defaults.__name = "default"

Defaults.events = {}
Defaults.entities = {}

if not _G.requirePackage then
    function _G.requirePackage(name, isInternal)
        local luaVersion = _VERSION:match("%d+%.%d+")
        local location = not isInternal and "/deps/share/lua/"..luaVersion.."/" or "/"
        local spoonPath = debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
        local packagePath = spoonPath..location..name..".lua"

        return dofile(packagePath)
    end
end

local File = _G.requirePackage("file", true)

local entities = {
    ActivityMonitor = _G.requirePackage("entities/activity-monitor", true),
    AppStore = _G.requirePackage("entities/app-store", true),
    Books = _G.requirePackage("entities/books", true),
    Calendar = _G.requirePackage("entities/calendar", true),
    Calculator = _G.requirePackage("entities/calculator", true),
    Contacts = _G.requirePackage("entities/contacts", true),
    Dictionary = _G.requirePackage("entities/dictionary", true),
    FaceTime = _G.requirePackage("entities/facetime", true),
    Finder = _G.requirePackage("entities/finder", true),
    GoogleChrome = _G.requirePackage("entities/google-chrome", true),
    Home = _G.requirePackage("entities/home", true),
    iTunes = _G.requirePackage("entities/itunes", true),
    Maps = _G.requirePackage("entities/maps", true),
    Mail = _G.requirePackage("entities/mail", true),
    Messages = _G.requirePackage("entities/messages", true),
    News = _G.requirePackage("entities/news", true),
    Notes = _G.requirePackage("entities/notes", true),
    PhotoBooth = _G.requirePackage("entities/photo-booth", true),
    Photos = _G.requirePackage("entities/photos", true),
    Preview = _G.requirePackage("entities/preview", true),
    QuickTimePlayer = _G.requirePackage("entities/quicktime-player", true),
    Reminders = _G.requirePackage("entities/reminders", true),
    Safari = _G.requirePackage("entities/Safari", true),
    Siri = _G.requirePackage("entities/siri", true),
    Spotify = _G.requirePackage("entities/spotify", true),
    Stickies = _G.requirePackage("entities/stickies", true),
    SystemPreferences = _G.requirePackage("entities/system-preferences", true),
    Terminal = _G.requirePackage("entities/terminal", true),
    TextEdit = _G.requirePackage("entities/text-edit", true),
    VoiceMemos = _G.requirePackage("entities/voice-memos", true),
}

--- Defaults.createFileEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `file` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `file` workflow events
function Defaults.createFileEvents()
    local finderAppLocation = "/System/Library/CoreServices/Finder.app/Contents/Applications"
    local function openFinderAppEvent(name)
        return function()
            hs.execute("open "..finderAppLocation.."/"..name..".app")
            return true
        end
    end

    local fileEvents = {
        { nil, "a", File:new("/Applications"), { "Files", "Applications" } },
        { nil, "d", File:new("~/Downloads"), { "Files", "Downloads" } },
        { nil, "h", File:new("~"), { "Files", "$HOME" } },
        { nil, "m", File:new("~/Movies"), { "Files", "Movies" } },
        { nil, "p", File:new("~/Pictures"), { "Files", "Pictures" } },
        { nil, "t", File:new("~/.Trash"), { "Files", "Trash" } },
        { { "cmd" }, "a", openFinderAppEvent("Airdrop"), { "Files", "Airdrop" } },
        { { "cmd" }, "c", openFinderAppEvent("Computer"), { "Files", "Computer" } },
        { { "cmd" }, "i", openFinderAppEvent("iCloud Drive"), { "Files", "iCloud Drive" } },
        { { "cmd" }, "n", openFinderAppEvent("Network"), { "Files", "Network" } },
        { { "cmd" }, "r", openFinderAppEvent("Recents"), { "Files", "Recents" } },
        { { "shift" }, "a", openFinderAppEvent("All My Files"), { "Files", "All My Files" } },
        { { "shift" }, "d", File:new("~/Desktop"), { "Files", "Desktop" } },
        { { "cmd", "shift" }, "d", File:new("~/Documents"), { "Files", "Documents" } },
    }

    return fileEvents
end

--- Defaults.createEntityEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `entity` and `select` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `entity` workflow events
---  * A list of `select` workflow events
function Defaults.createEntityEvents()
    local entityEvents = {
        { nil, "a", entities.AppStore, { "Entities", "App Store" } },
        { nil, "b", entities.Books, { "Entities", "Books" } },
        { nil, "c", entities.Calendar, { "Entities", "Calendar" } },
        { nil, "d", entities.Dictionary, { "Entities", "Dictionary" } },
        { nil, "f", entities.Finder, { "Entities", "Finder" } },
        { nil, "g", entities.GoogleChrome, { "Entities", "Google Chrome" } },
        { nil, "h", entities.Home, { "Entities", "Home" } },
        { nil, "i", entities.iTunes, { "Entities", "iTunes" } },
        { nil, "m", entities.Messages, { "Entities", "Messages" } },
        { nil, "n", entities.Notes, { "Entities", "Notes" } },
        { nil, "p", entities.Preview, { "Entities", "Preview" } },
        { nil, "q", entities.QuickTimePlayer, { "Entities", "QuickTime Player" } },
        { nil, "r", entities.Reminders, { "Entities", "Reminders" } },
        { nil, "s", entities.Safari, { "Entities", "Safari" } },
        { nil, "t", entities.Terminal, { "Entities", "Terminal" } },
        { nil, "v", entities.VoiceMemos, { "Entities", "Voice Memos" } },
        { nil, ",", entities.SystemPreferences, { "Entities", "System Preferences" } },
        { { "alt", "cmd" }, "s", entities.Siri, { "Entities", "Siri" } },
        { { "shift" }, "a", entities.ActivityMonitor, { "Entities", "Activity Monitor" } },
        { { "shift" }, "c", entities.Calculator, { "Entities", "Calculator" } },
        { { "shift" }, "f", entities.FaceTime, { "Entities", "FaceTime" } },
        { { "shift" }, "m", entities.Maps, { "Entities", "Maps" } },
        { { "shift" }, "n", entities.News, { "Entities", "News" } },
        { { "shift" }, "p", entities.PhotoBooth, { "Entities", "Photo Booth" } },
        { { "shift" }, "s", entities.Spotify, { "Entities", "Spotify" } },
        { { "shift" }, "t", entities.TextEdit, { "Entities", "Text Edit" } },
        { { "shift", "cmd" }, "c", entities.Contacts, { "Entities", "Contacts" } },
        { { "shift", "cmd" }, "p", entities.Photos, { "Entities", "Photos" } },
        { { "shift", "cmd" }, "m", entities.Mail, { "Entities", "Mail" } },
        { { "shift", "cmd" }, "s", entities.Stickies, { "Entities", "Stickies" } },
    }

    local entitySelectEvents = {
        { nil, "d", entities.Dictionary, { "Entities", "Select a Dictionary window" } },
        { nil, "f", entities.Finder, { "Select Events", "Select a Finder window" } },
        { nil, "g", entities.GoogleChrome, { "Select Events", "Select a Google Chrome tab or window" } },
        { nil, "m", entities.Messages, { "Select Events", "Select a Messages conversation" } },
        { nil, "n", entities.Notes, { "Select Events", "Select a Note" } },
        { nil, "p", entities.Preview, { "Select Events", "Select a Preview window" } },
        { nil, "s", entities.Safari, { "Select Events", "Select a Safari tab or window" } },
        { nil, "t", entities.Terminal, { "Select Events", "Select a Terminal window" } },
        { { "shift" }, "t", entities.TextEdit, { "Select Events", "Select a Text Edit window" } },
    }

    return entityEvents, entitySelectEvents
end

--- Defaults.createUrlEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `url` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `url` workflow events
function Defaults.createUrlEvents()
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

--- Defaults.createVolumeEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `volume` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `volume` workflow events
function Defaults.createVolumeEvents()
    local function turnVolumeDown()
        local newVolume = hs.audiodevice.current().volume - 10
        hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
    end

    local function turnVolumeUp()
        local newVolume = hs.audiodevice.current().volume + 10
        hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
    end

    local function toggleMute()
        local isMuted = hs.audiodevice.defaultOutputDevice():muted()
        hs.audiodevice.defaultOutputDevice():setMuted(isMuted)
        return true
    end

    local volumeEvents = {
        { nil, "j", turnVolumeDown, { "Volume Control Mode", "Turn Volume Down" } },
        { nil, "k", turnVolumeUp, { "Volume Control Mode", "Turn Volume Up" } },
        { nil, "m", toggleMute, { "Volume Control Mode", "Mute or Unmute Volume" } },
    }

    local function createVolumeToPercentageEvent(percentage)
        return function()
            hs.audiodevice.defaultOutputDevice():setVolume(percentage)
            return true
        end
    end

    for number = 0, 9 do
        local percent = number * 100 / 9
        table.insert(volumeEvents, {
            nil,
            tostring(number),
            createVolumeToPercentageEvent(percent),
            { "Volume Control Mode", "Set Volume to "..tostring(math.floor(percent)).."%" },
        })
    end

    return volumeEvents
end

--- Defaults.createBrightnessEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `brightness` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `brightness` workflow events
function Defaults.createBrightnessEvents()
    local function turnBrightnessDown()
        local newBrightness = hs.brightness.get() - 10
        hs.brightness.set(newBrightness)
    end

    local function turnBrightnessUp()
        local newBrightness = hs.brightness.get() + 10
        hs.brightness.set(newBrightness)
    end

    local function createBrightnessToPercentageEvent(percentage)
        return function()
            hs.brightness.set(math.floor(percentage))
            return true
        end
    end

    local brightnessEvents = {
        { nil, "j", turnBrightnessDown, { "Brightness Control Mode", "Turn Brightness Down" } },
        { nil, "k", turnBrightnessUp, { "Brightness Control Mode", "Turn Brightness Up" } },
    }

    for number = 0, 9 do
        local percent = number * 100 / 9
        table.insert(brightnessEvents, {
            nil,
            tostring(number),
            createBrightnessToPercentageEvent(percent),
            { "Brightness Control Mode", "Set Brightness to "..tostring(math.floor(percent)).."%" },
        })
    end

    return brightnessEvents
end

--- Defaults.createNormalEvents()
--- Method
--- Defines the initial set of actions with predefined keybindings for `normal` mode
---
--- Parameters:
---  * None
---
--- Returns:
---  * A list of `normal` workflow events
function Defaults.createNormalEvents(Ki)
    local function startScreenSaver()
        hs.osascript.applescript([[
            tell application "System Events" to start current screen saver
        ]])

        return true
    end

    local function sleep()
        Ki.state:exitMode()
        hs.osascript.applescript([[ tell application "Finder" to sleep ]])
    end

    local function restart()
        Ki.state:exitMode()

        local answer = hs.dialog.blockAlert("Restart your computer?", "", "Restart", "Cancel")

        if answer == "Restart" then
            hs.osascript.applescript([[ tell application "Finder" to restart ]])
        end
    end

    local function shutdown()
        Ki.state:exitMode()

        local answer = hs.dialog.blockAlert("Shut down your computer?", "", "Shut Down", "Cancel")

        if answer == "Shut Down" then
            hs.osascript.applescript([[ tell application "System Events" to shut down ]])
        end
    end

    local normalEvents = {
        { { "ctrl" }, "q", shutdown, { "Normal Mode", "Shut Down" } },
        { { "ctrl" }, "s", sleep, { "Normal Mode", "Sleep" } },
        { { "ctrl" }, "r", restart, { "Normal Mode", "Restart" } },
        { { "cmd", "ctrl" }, "s", startScreenSaver, { "Normal Mode", "Enter Screen Saver" } },
    }

    return normalEvents
end

--- Defaults.create(Ki) -> events, entities
--- Method
--- Creates the default Ki events and entities
---
--- Parameters:
---  * Ki - the Ki object
---
--- Returns:
---   * A table containing events for `url`, `select`, `entity`, `volume`, `brightness`, and `normal` modes
---   * A table containing all default desktop entity objects
function Defaults.create(Ki)
    local urlEvents = Defaults.createUrlEvents()
    local entityEvents, entitySelectEvents = Defaults.createEntityEvents()
    local fileEvents = Defaults.createFileEvents()
    local volumeEvents = Defaults.createVolumeEvents()
    local brightnessEvents = Defaults.createBrightnessEvents()
    local normalEvents = Defaults.createNormalEvents(Ki)
    local events = {
        url = urlEvents,
        select = entitySelectEvents,
        entity = entityEvents,
        file = fileEvents,
        volume = volumeEvents,
        brightness = brightnessEvents,
        normal = normalEvents,
    }

    return events, entities
end

return Defaults
