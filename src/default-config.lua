----------------------------------------------------------------------------------------------------
-- Default config
--
-- Definitions and configuration of default entities and worfklow events
--
-- luacov: disable
local File = spoon.Ki.File
local spoonPath = hs.spoons.scriptPath()

-- Add entities directory to package path and add helper require function
package.path = package.path..";"..spoonPath.."entities/?.lua"
local function requireEntity(type, filename)
    return require(type.."."..filename)
end

-- Initialize entities and assign shortcuts
local entities = {
    ActivityMonitor = requireEntity("application", "activity-monitor"),
    AppStore = requireEntity("application", "app-store"),
    Books = requireEntity("application", "books"),
    Calendar = requireEntity("application", "calendar"),
    Calculator = requireEntity("application", "calculator"),
    Contacts = requireEntity("application", "contacts"),
    Dictionary = requireEntity("application", "dictionary"),
    DiskUtility = requireEntity("application", "disk-utility"),
    FaceTime = requireEntity("application", "facetime"),
    Finder = requireEntity("application", "finder"),
    GoogleChrome = requireEntity("application", "google-chrome"),
    Home = requireEntity("application", "home"),
    iTunes = requireEntity("application", "itunes"),
    Maps = requireEntity("application", "maps"),
    Mail = requireEntity("application", "mail"),
    Messages = requireEntity("application", "messages"),
    News = requireEntity("application", "news"),
    Notes = requireEntity("application", "notes"),
    PhotoBooth = requireEntity("application", "photo-booth"),
    Photos = requireEntity("application", "photos"),
    Preview = requireEntity("application", "preview"),
    QuickTimePlayer = requireEntity("application", "quicktime-player"),
    Reminders = requireEntity("application", "reminders"),
    Safari = requireEntity("application", "safari"),
    Siri = requireEntity("application", "siri"),
    Spotify = requireEntity("application", "spotify"),
    Stickies = requireEntity("application", "stickies"),
    SystemPreferences = requireEntity("application", "system-preferences"),
    Terminal = requireEntity("application", "terminal"),
    TextEdit = requireEntity("application", "text-edit"),
    VoiceMemos = requireEntity("application", "voice-memos"),
}
local entityShortcuts = {
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
    { { "cmd" }, "d", entities.DiskUtility, { "Entities", "Disk Utility" } },
    { { "option", "cmd" }, "s", entities.Siri, { "Entities", "Siri" } },
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
local selectEntityShortcuts = {
    { nil, "d", entities.Dictionary, { "Entities", "Select a Dictionary window" } },
    { nil, "f", entities.Finder, { "Select Events", "Select a Finder window" } },
    { nil, "g", entities.GoogleChrome, { "Select Events", "Select a Google Chrome tab or window" } },
    { nil, "m", entities.Messages, { "Select Events", "Select a Messages conversation" } },
    { nil, "n", entities.Notes, { "Select Events", "Select a Note" } },
    { nil, "p", entities.Preview, { "Select Events", "Select a Preview window" } },
    { nil, "q", entities.QuickTimePlayer, { "Select Events", "QuickTime Player" } },
    { nil, "s", entities.Safari, { "Select Events", "Select a Safari tab or window" } },
    { nil, "t", entities.Terminal, { "Select Events", "Select a Terminal window" } },
    { nil, ",", entities.SystemPreferences, { "Entities", "Select a System Preferences pane" } },
    { { "shift" }, "t", entities.TextEdit, { "Select Events", "Select a Text Edit window" } },
}

-- Initialize file entities and assign shortcuts
local function openFinderApplicationEvent(name)
    return function()
        hs.application.launchOrFocus(name)
        return true
    end
end
local files = {
    Airdrop = openFinderApplicationEvent("Airdrop"),
    AllMyFiles = openFinderApplicationEvent("All My Files"),
    Applications = File:new("/Applications"),
    Computer = openFinderApplicationEvent("Computer"),
    Desktop = File:new("~/Desktop"),
    Documents = File:new("~/Documents"),
    Downloads = File:new("~/Downloads"),
    Home = File:new("~"),
    iCloudDrive = openFinderApplicationEvent("iCloud Drive"),
    Movies = File:new("~/Movies"),
    Network = openFinderApplicationEvent("Network"),
    Pictures = File:new("~/Pictures"),
    Recents = openFinderApplicationEvent("Recents"),
    Trash = File:new("~/.Trash"),
    Volumes = File:new("/Volumes"),
}
local fileShortcuts = {
    { nil, "a", files.Applications, { "Files", "Applications" } },
    { nil, "d", files.Downloads, { "Files", "Downloads" } },
    { nil, "h", files.Home, { "Files", "$HOME" } },
    { nil, "m", files.Movies, { "Files", "Movies" } },
    { nil, "p", files.Pictures, { "Files", "Pictures" } },
    { nil, "t", files.Trash, { "Files", "Trash" } },
    { nil, "v", files.Volumes, { "Files", "Volumes" } },
    { { "cmd" }, "a", files.Airdrop, { "Files", "Airdrop" } },
    { { "cmd" }, "c", files.Computer, { "Files", "Computer" } },
    { { "cmd" }, "i", files.iCloudDrive, { "Files", "iCloud Drive" } },
    { { "cmd" }, "n", files.Network, { "Files", "Network" } },
    { { "cmd" }, "r", files.Recents, { "Files", "Recents" } },
    { { "shift" }, "a", files.AllMyFiles, { "Files", "All My Files" } },
    { { "shift" }, "d", files.Desktop, { "Files", "Desktop" } },
    { { "cmd", "shift" }, "d", files.Documents, { "Files", "Documents" } },
}

-- Initialize URL entities and assign shortcuts
local urls = {
    Amazon = requireEntity("url", "amazon"),
    Facebook = requireEntity("url", "facebook"),
    GitHub = requireEntity("url", "github"),
    GMail = requireEntity("url", "gmail"),
    Google = requireEntity("url", "google"),
    GoogleMaps = requireEntity("url", "google-maps"),
    HackerNews = requireEntity("url", "hacker-news"),
    LinkedIn = requireEntity("url", "linkedin"),
    Messenger = requireEntity("url", "messenger"),
    Netflix = requireEntity("url", "netflix"),
    Reddit = requireEntity("url", "reddit"),
    Twitter = requireEntity("url", "twitter"),
    Wikipedia = requireEntity("url", "wikipedia"),
    Weather = requireEntity("url", "weather"),
    Yelp = requireEntity("url", "yelp"),
    YouTube = requireEntity("url", "youtube"),
    Zillow = requireEntity("url", "zillow"),
}
local urlShortcuts = {
    { nil, "a", urls.Amazon, { "URL Events", "Amazon" } },
    { nil, "f", urls.Facebook, { "URL Events", "Facebook" } },
    { nil, "g", urls.Google, { "URL Events", "Google" } },
    { nil, "h", urls.HackerNews, { "URL Events", "Hacker News" } },
    { nil, "l", urls.LinkedIn, { "URL Events", "LinkedIn" } },
    { nil, "m", urls.Messenger, { "URL Events", "Facebook Messenger" } },
    { nil, "n", urls.Netflix, { "URL Events", "Netflix" } },
    { nil, "r", urls.Reddit, { "URL Events", "Reddit" } },
    { nil, "t", urls.Twitter, { "URL Events", "Twitter" } },
    { nil, "w", urls.Wikipedia, { "URL Events", "Wikipedia" } },
    { nil, "y", urls.YouTube, { "URL Events", "YouTube" } },
    { nil, "z", urls.Zillow, { "URL Events", "Zillow" } },
    { { "shift" }, "g", urls.GitHub, { "URL Events", "GitHub" } },
    { { "shift" }, "m", urls.GoogleMaps, { "URL Events", "Google Maps" } },
    { { "shift" }, "w", urls.Weather, { "URL Events", "Weather" } },
    { { "shift" }, "y", urls.Yelp, { "URL Events", "Yelp" } },
    { { "cmd", "shift" }, "m", urls.GMail, { "URL Events", "Gmail" } },
}

-- Initialize entities tied to specific modes
local System = requireEntity("entity", "system")
local Volume = requireEntity("entity", "volume")
local Brightness = requireEntity("entity", "brightness")

local shortcuts = {
    normal = System.shortcuts,
    volume = Volume.shortcuts,
    brightness = Brightness.shortcuts,
    entity = entityShortcuts,
    select = selectEntityShortcuts,
    file = fileShortcuts,
    url = urlShortcuts,
}

return {
    shortcuts = shortcuts,
    entities = {
        normal = System,
        volume = Volume,
        brightness = Brightness,
        entity = entities,
        file = files,
        url = urls,
    },
}
