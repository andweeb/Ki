--- === ModeIndicator ===
---
--- Mode indicator implementation that displays the current Ki mode in a menubar item
---

local ModeIndicator = {}
local spoonPath = hs.spoons.scriptPath()

ModeIndicator.timer = nil
ModeIndicator.isDefault = true
ModeIndicator.menubar = hs.menubar.new()

--- ModeIndicator.isDarkMode
--- Variable
--- A boolean value indicating whether the menu bar style is in dark mode. This value will be determined automatically.
ModeIndicator.isDarkMode = false

-- Text styles
local smallMenlo = { name = "Menlo", size = 9 }
local darkColor = { red = 0.2, blue = 0.2, green = 0.2 }
local darkTextStyle = { color = darkColor, font = smallMenlo }
local lightColor = { red = 0.8, blue = 0.8, green = 0.8 }
local lightTextStyle = { color = lightColor, font = smallMenlo }

--- ModeIndicator:show(mode)
--- Method
--- Shows a text display on center of the menu bar to indicate the current mode
---
--- Parameters:
---  * `mode` - a string value containing the current mode (i.e., `"normal"`, `"entity"`, etc.)
---
--- Returns:
---  * None
function ModeIndicator:show(mode)
    -- Interrupt fade-out timer if running
    if self.timer and self.timer:running() then
        self.timer:stop()
    end

    -- Determine based on dark mode status which style is faded or normal
    local fadedTextStyle = self.isDarkMode and lightTextStyle or darkTextStyle
    local normalTextStyle = self.isDarkMode and darkTextStyle or lightTextStyle

    -- Stylize text and update title in menu bar
    local text = "-- "..mode:upper().." --"
    local textElement = hs.styledtext.new(text, fadedTextStyle)
    self.menubar:setTitle(textElement)

    -- Dim desktop mode text after some timeout
    if mode == "desktop" then
        self.timer = hs.timer.doAfter(0.5, function()
            self.menubar:setTitle(hs.styledtext.new(text, normalTextStyle))
        end)
    end
end

-- Handle streaming task output
function ModeIndicator:handleTaskOutput(_, stdout)
    if stdout == "Dark" then
        self.isDarkMode = true
        return false
    end

    return true
end

-- Initialize mode indicator with desktop mode
function ModeIndicator:initialize()
    self:show("desktop")
end

-- Start swift task in the background to retrieve the dark mode status
local swiftBin = "/usr/bin/swift"
local swiftFile = spoonPath.."bin/print-dark-mode.swift"
local taskDoneCallback = function(...) return ModeIndicator:initialize(...) end
local streamingCallback = function(...) return ModeIndicator:handleTaskOutput(...) end
local getDarkModeTask = hs.task.new(swiftBin, taskDoneCallback, streamingCallback, { swiftFile })
getDarkModeTask:start()

return ModeIndicator
