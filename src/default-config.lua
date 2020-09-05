----------------------------------------------------------------------------------------------------
-- Default config
--
-- Configuration of default macOS entities and their shortcuts
--
-- luacov: disable
local Ki = spoon.Ki
local File = spoon.Ki.File
local spoonPath = hs.spoons.scriptPath()

-- Add entities directory to package path and add helper require function
package.path = package.path..";"..spoonPath.."entities/?.lua"
local function requireEntity(type, filename)
    local directory = type == "entity" and "entities" or type.."s"
    return require(directory.."."..filename)
end

-- Initialize entities
local entities = {
    ActivityMonitor   = requireEntity("application", "activity-monitor"),
    AppStore          = requireEntity("application", "app-store"),
    Books             = requireEntity("application", "books"),
    Calendar          = requireEntity("application", "calendar"),
    Calculator        = requireEntity("application", "calculator"),
    Contacts          = requireEntity("application", "contacts"),
    Dictionary        = requireEntity("application", "dictionary"),
    DiskUtility       = requireEntity("application", "disk-utility"),
    FaceTime          = requireEntity("application", "facetime"),
    Finder            = requireEntity("application", "finder"),
    GoogleChrome      = requireEntity("application", "google-chrome"),
    Home              = requireEntity("application", "home"),
    iTunes            = requireEntity("application", "itunes"),
    Maps              = requireEntity("application", "maps"),
    Mail              = requireEntity("application", "mail"),
    Messages          = requireEntity("application", "messages"),
    News              = requireEntity("application", "news"),
    Notes             = requireEntity("application", "notes"),
    PhotoBooth        = requireEntity("application", "photo-booth"),
    Photos            = requireEntity("application", "photos"),
    Preview           = requireEntity("application", "preview"),
    QuickTimePlayer   = requireEntity("application", "quicktime-player"),
    Reminders         = requireEntity("application", "reminders"),
    Safari            = requireEntity("application", "safari"),
    Siri              = requireEntity("application", "siri"),
    Spotify           = requireEntity("application", "spotify"),
    Stickies          = requireEntity("application", "stickies"),
    System            = requireEntity("entity", "system"),
    SystemPreferences = requireEntity("application", "system-preferences"),
    Terminal          = requireEntity("application", "terminal"),
    TextEdit          = requireEntity("application", "text-edit"),
    VoiceMemos        = requireEntity("application", "voice-memos"),
}
-- Register entity mode shortcuts
Ki:registerModeShortcuts("entity", {
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
    { { "alt", "cmd" }, "s", entities.Siri, { "Entities", "Siri" } },
    { { "ctrl", "cmd" }, "s", entities.System, { "Entities", "System" } },
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
})

-- Register select mode and assign shortcuts for applicable entities that implement selection
local enterSelectModeShortcut = { {"cmd"}, "s", nil, { "Normal Mode", "Enter Select Mode" } }
Ki:registerMode("select", enterSelectModeShortcut, {
    { nil, "d", entities.Dictionary, { "Select Events", "Select a Dictionary window" } },
    { nil, "f", entities.Finder, { "Select Events", "Select a Finder window" } },
    { nil, "g", entities.GoogleChrome, { "Select Events", "Select a Google Chrome tab or window" } },
    { nil, "m", entities.Messages, { "Select Events", "Select a Messages conversation" } },
    { nil, "n", entities.Notes, { "Select Events", "Select a Note" } },
    { nil, "p", entities.Preview, { "Select Events", "Select a Preview window" } },
    { nil, "q", entities.QuickTimePlayer, { "Select Events", "QuickTime Player" } },
    { nil, "s", entities.Safari, { "Select Events", "Select a Safari tab or window" } },
    { nil, "t", entities.Terminal, { "Select Events", "Select a Terminal window" } },
    { nil, ",", entities.SystemPreferences, { "Select Events", "Select a System Preferences pane" } },
    { { "shift" }, "t", entities.TextEdit, { "Select Events", "Select a Text Edit window" } },
})
-- Register mode transitions between select mode and others
Ki:registerModeTransition("entity", "select", { {"cmd"}, "s", nil, { "Entity Mode", "Enter Select Mode" } })
Ki:registerModeTransition("select", "entity", { {"cmd"}, "e", nil, { "Select Mode", "Enter Entity Mode" } })
Ki:registerModeTransition("select", "file", { {"cmd"}, "f", nil, { "Select Mode", "Enter File Mode" } })
Ki:registerModeTransition("select", "website", { {"cmd"}, "w", nil, { "Select Mode", "Enter Website Mode" } })

-- Initialize file entities
local function openFinderApplicationEvent(name)
    return function()
        return hs.application.launchOrFocus(name)
    end
end
local files = {
    Applications = File "/Applications",
    Desktop      = File "~/Desktop",
    Documents    = File "~/Documents",
    Downloads    = File "~/Downloads",
    Home         = File "~",
    Library      = File "~/Library",
    Movies       = File "~/Movies",
    Pictures     = File "~/Pictures",
    System       = File "/System",
    Trash        = File "~/.Trash",
    Users        = File "/Users",
    Volumes      = File "/Volumes",
    Airdrop      = openFinderApplicationEvent("Airdrop"),
    AllMyFiles   = openFinderApplicationEvent("All My Files"),
    Computer     = openFinderApplicationEvent("Computer"),
    iCloudDrive  = openFinderApplicationEvent("iCloud Drive"),
    Network      = openFinderApplicationEvent("Network"),
    Recents      = openFinderApplicationEvent("Recents"),
}
-- Register file mode and assign shortcuts for the initialized file entities
local enterFileModeShortcut = { {"cmd"}, "f", nil, { "Normal Mode", "Enter File Mode" } }
Ki:registerMode("file", enterFileModeShortcut, {
    { nil, "a", files.Applications, { "Files", "Applications" } },
    { nil, "d", files.Downloads, { "Files", "Downloads" } },
    { nil, "h", files.Home, { "Files", "$HOME" } },
    { nil, "l", files.Library, { "Files", "Library" } },
    { nil, "m", files.Movies, { "Files", "Movies" } },
    { nil, "p", files.Pictures, { "Files", "Pictures" } },
    { nil, "s", files.System, { "Files", "System" } },
    { nil, "t", files.Trash, { "Files", "Trash" } },
    { nil, "u", files.Users, { "Files", "Users" } },
    { nil, "v", files.Volumes, { "Files", "Volumes" } },
    { { "cmd" }, "a", files.Airdrop, { "Files", "Airdrop" } },
    { { "cmd" }, "c", files.Computer, { "Files", "Computer" } },
    { { "cmd" }, "i", files.iCloudDrive, { "Files", "iCloud Drive" } },
    { { "cmd" }, "n", files.Network, { "Files", "Network" } },
    { { "cmd" }, "r", files.Recents, { "Files", "Recents" } },
    { { "shift" }, "a", files.AllMyFiles, { "Files", "All My Files" } },
    { { "shift" }, "d", files.Desktop, { "Files", "Desktop" } },
    { { "cmd", "shift" }, "d", files.Documents, { "Files", "Documents" } },
})
-- Register mode transitions to allow transitioning from entity to file mode
Ki:registerModeTransition("entity", "file", { {"cmd"}, "f", nil, { "Entity Mode", "Enter File Mode" } })

-- Initialize website entities
local websites = {
    Amazon     = requireEntity("website", "amazon"),
    Facebook   = requireEntity("website", "facebook"),
    GitHub     = requireEntity("website", "github"),
    GMail      = requireEntity("website", "gmail"),
    Google     = requireEntity("website", "google"),
    GoogleMaps = requireEntity("website", "google-maps"),
    HackerNews = requireEntity("website", "hacker-news"),
    LinkedIn   = requireEntity("website", "linkedin"),
    Messenger  = requireEntity("website", "messenger"),
    Netflix    = requireEntity("website", "netflix"),
    Reddit     = requireEntity("website", "reddit"),
    Twitter    = requireEntity("website", "twitter"),
    Wikipedia  = requireEntity("website", "wikipedia"),
    Weather    = requireEntity("website", "weather"),
    Yelp       = requireEntity("website", "yelp"),
    YouTube    = requireEntity("website", "youtube"),
    Zillow     = requireEntity("website", "zillow"),
}
-- Register Website mode and assign shortcuts for the initialized website entities
local enterWebsiteModeShortcut = { {"cmd"}, "w", nil, { "Normal Mode", "Enter Website Mode" } }
Ki:registerMode("website", enterWebsiteModeShortcut, {
    { nil, "a", websites.Amazon, { "Websites", "Amazon" } },
    { nil, "f", websites.Facebook, { "Websites", "Facebook" } },
    { nil, "g", websites.Google, { "Websites", "Google" } },
    { nil, "h", websites.HackerNews, { "Websites", "Hacker News" } },
    { nil, "l", websites.LinkedIn, { "Websites", "LinkedIn" } },
    { nil, "m", websites.Messenger, { "Websites", "Facebook Messenger" } },
    { nil, "n", websites.Netflix, { "Websites", "Netflix" } },
    { nil, "r", websites.Reddit, { "Websites", "Reddit" } },
    { nil, "t", websites.Twitter, { "Websites", "Twitter" } },
    { nil, "w", websites.Wikipedia, { "Websites", "Wikipedia" } },
    { nil, "y", websites.YouTube, { "Websites", "YouTube" } },
    { nil, "z", websites.Zillow, { "Websites", "Zillow" } },
    { { "shift" }, "g", websites.GitHub, { "Websites", "GitHub" } },
    { { "shift" }, "m", websites.GoogleMaps, { "Websites", "Google Maps" } },
    { { "shift" }, "w", websites.Weather, { "Websites", "Weather" } },
    { { "shift" }, "y", websites.Yelp, { "Websites", "Yelp" } },
    { { "cmd", "shift" }, "m", websites.GMail, { "Websites", "Gmail" } },
})
-- Register mode transitions to allow transitioning from entity to website mode
Ki:registerModeTransition("entity", "website", { {"cmd"}, "w", nil, { "Entity Mode", "Enter Website Mode" } })

-- Register volume mode and assign shortcuts
local Volume = requireEntity("entity", "volume")
local enterVolumeModeShortcut = { {"cmd"}, "v", nil, { "Normal Mode", "Enter Volume Mode" } }
Ki:registerMode("volume", enterVolumeModeShortcut, Volume.shortcuts)

-- Register brightness mode and assign shortcuts
local Brightness = requireEntity("entity", "brightness")
local enterBrightnessModeShortcut = { {"cmd"}, "b", nil, { "Normal Mode", "Enter Brightness Mode" } }
Ki:registerMode("brightness", enterBrightnessModeShortcut, Brightness.shortcuts)

-- Set default entities
Ki.defaultEntities = {
    volume = Volume,
    brightness = Brightness,
    entity = entities,
    file = files,
    website = websites,
}
