local obj = {}
obj.__index = obj
obj.__name = 'status-display'

obj.DEFAULT_WIDTH = 500
obj.DEFAULT_HEIGHT = 18
obj.DEFAULT_FADE_TIMEOUT = 0.8

obj.displays = {}

function obj:createTextElement(text)
    return {
        type = 'text',
        frame = {
            x = 0,
            y = 0,
            w = self.DEFAULT_WIDTH,
            h = self.DEFAULT_HEIGHT,
        },
        text = hs.styledtext.new(text, {
            color = { red = 0.8, blue = 0.8, green = 0.8 },
            font = { name = 'Menlo', size = 10 },
            paragraphStyle = { alignment = 'center' },
        }),
    }
end

function obj:show(status, action)
    -- Clear any pre-existing status display canvases
    for state, display in pairs(self.displays) do
        if display ~= nil then
            display:delete()
            self.displays[state] = nil
        end
    end

    local screenFrame = hs.window.focusedWindow():screen():frame()
    local dimensions = {
        x = screenFrame.x + (screenFrame.w / 2) - (self.DEFAULT_WIDTH / 2),
        y = screenFrame.y - self.DEFAULT_HEIGHT,
        h = self.DEFAULT_HEIGHT,
        w = self.DEFAULT_WIDTH,
    }
    local statusText = status:upper()
    local text = action and statusText..' ('..action..')' or statusText
    local textElement = self:createTextElement('-- '..text..' --')
    local screenFrame = hs.window.focusedWindow():screen():frame()
    local display = hs.canvas.new(dimensions):appendElements({ textElement }):show()

    self.displays[status] = display

    if status == 'normal' then
        display:delete(self.DEFAULT_FADE_TIMEOUT)
        self.displays[status] = nil
    end
end

return obj
