--- === StatusDisplay ===
---
--- Small menubar text display
---

local StatusDisplay = {}
local spoonPath = hs.spoons.scriptPath()

StatusDisplay.timer = nil
StatusDisplay.isDefault = true
StatusDisplay.menubar = hs.menubar.new()

--- Ki.isDarkMode
--- Variable
--- A boolean value indicating whether the menu bar style is in dark mode. This value will be determined automatically.
StatusDisplay.isDarkMode = false

-- Text styles
local smallMenlo = { name = "Menlo", size = 9 }
local darkColor = { red = 0.2, blue = 0.2, green = 0.2 }
local darkTextStyle = { color = darkColor, font = smallMenlo }
local lightColor = { red = 0.8, blue = 0.8, green = 0.8 }
local lightTextStyle = { color = lightColor, font = smallMenlo }

--- StatusDisplay:show(status[, parenthetical])
--- Method
--- Shows a text display on center of the menu bar to indicate the current mode
---
--- Parameters:
---  * `status` - a string value containing the current mode (i.e., `"normal"`, `"entity"`, etc.)
---  * `parenthetical` - an optional string value of some parenthetical in the text display
---
--- Returns:
---  * None
function StatusDisplay:show(status)
    -- Interrupt fade-out timer if running
    if self.timer and self.timer:running() then
        self.timer:stop()
    end

    local fadedTextStyle = self.isDarkMode and lightTextStyle or darkTextStyle
    local normalTextStyle = self.isDarkMode and darkTextStyle or lightTextStyle

    -- Stylize text and update in menu bar
    local text = "-- "..status:upper().." --"
    local textElement = hs.styledtext.new(text, fadedTextStyle)
    self.menubar:setTitle(textElement)

    -- Fade out desktop mode status display in menu bar
    if status == "desktop" then
        self.timer = hs.timer.doAfter(0.5, function()
            self.menubar:setTitle(hs.styledtext.new(text, normalTextStyle))
        end)
    end
end

-- Handle streaming task output
function StatusDisplay:handleTaskOutput(_, stdout)
    if stdout == "Dark" then
        self.isDarkMode = true
        return false
    end

    return true
end

-- Initialize status display with desktop mode
function StatusDisplay:initialize()
    self:show("desktop")
end

-- Start swift task in the background to retrieve the dark mode status
local swiftBin = "/usr/bin/swift"
local swiftFile = spoonPath.."bin/print-dark-mode.swift"
local taskDoneCallback = function(...) return StatusDisplay:initialize(...) end
local streamingCallback = function(...) return StatusDisplay:handleTaskOutput(...) end
local getDarkModeTask = hs.task.new(swiftBin, taskDoneCallback, streamingCallback, { swiftFile })
getDarkModeTask:start()

return StatusDisplay
