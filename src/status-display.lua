--- === StatusDisplay ===
---
--- Small menubar text display
---

local StatusDisplay = {}
StatusDisplay.__index = StatusDisplay
StatusDisplay.__name = "status-display"

StatusDisplay.DEFAULT_WIDTH = 500
StatusDisplay.DEFAULT_HEIGHT = 18
StatusDisplay.DEFAULT_FADE_TIMEOUT = 0.8

StatusDisplay.displays = {}

local _, inDarkMode = hs.osascript.applescript([[
    tell application "System Events" to tell appearance preferences to return dark mode
]])

-- Create the canvas text element
function StatusDisplay:createTextElement(text)
    return {
        type = "text",
        frame = {
            x = 0,
            y = 0,
            w = self.DEFAULT_WIDTH,
            h = self.DEFAULT_HEIGHT,
        },
        text = hs.styledtext.new(text, {
            color = inDarkMode
                and { red = 0.8, blue = 0.8, green = 0.8 }
                or { red = 0, blue = 0, green = 0 },
            font = { name = "Menlo", size = 10 },
            paragraphStyle = { alignment = "center" },
        }),
    }
end

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
function StatusDisplay:show(status, parenthetical)
    -- Clear any pre-existing status display canvases
    for state, display in pairs(self.displays) do
        if display ~= nil then
            display:delete()
            self.displays[state] = nil
        end
    end

    local screenFrame = hs.screen.mainScreen():frame()
    local dimensions = {
        x = screenFrame.x + (screenFrame.w / 2) - (self.DEFAULT_WIDTH / 2),
        y = screenFrame.y - self.DEFAULT_HEIGHT,
        h = self.DEFAULT_HEIGHT,
        w = self.DEFAULT_WIDTH,
    }
    local statusText = status:upper()
    local text = parenthetical and statusText.." ("..parenthetical..")" or statusText
    local textElement = self:createTextElement("-- "..text.." --", inDarkMode)
    local display = hs.canvas.new(dimensions):appendElements({ textElement }):show()

    self.displays[status] = display

    if status == "desktop" then
        display:delete(self.DEFAULT_FADE_TIMEOUT)
        self.displays[status] = nil
    end
end

return StatusDisplay
