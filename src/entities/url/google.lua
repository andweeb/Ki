----------------------------------------------------------------------------------------------------
-- Google URL entity
--
local URL = spoon.Ki.URL
local baseURL = "https://google.com"
local Google = URL:new(baseURL)

Google.paths = {
    { name = "Google Search", path = baseURL },
    { name = "Google Image Search", path = "/imghp" },
    { name = "Google Account", path = "https://myaccount.google.com" },
    { name = "Google Calendar", path = "https://www.google.com/calendar" },
    { name = "Google Contacts", path = "https://contacts.google.com" },
    { name = "Google Drive", path = "https://drive.google.com" },
    { name = "Google Maps", path = "https://maps.google.com" },
    { name = "Google Play Store", path = "https://play.google.com" },
    { name = "Google News", path = "https://news.google.com" },
    { name = "Google Photos", path = "https://photos.google.com" },
    { name = "Google Shopping", path = "https://www.google.com/shopping" },
    { name = "Google Translate", path = "https://translate.google.com" },
    { name = "GMail", path = "https://mail.google.com" },
    { name = "YouTube", path = "https://www.youtube.com" },
}

return Google
