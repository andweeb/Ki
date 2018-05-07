--- === Ki ===
---
--- Enables macOS macros with composable commands
---
--- Download:

local ki = {}
ki.__index = ki

-- Metadata
ki.name = "Ki"
ki.version = "1.0.0"
ki.author = "Andrew Kwon"
ki.homepage = "https://github.com/andweeb/ki"
ki.license = "MIT - https://opensource.org/licenses/MIT"

local keyCodeMap = hs.keycodes.map

local modes = {
    normal = 'normal',
    entity = 'entity',
    action = 'action',
}

local modifiers = {
    none = {},
    alt = {'alt'},
    cmd = {'cmd'},
    ctrl = {'ctrl'},
    shift = {'shift'},
    altcmd = {'alt', 'cmd'},
    altshift = {'alt', 'shift'},
    altcmdshift = {'alt', 'cmd', 'shift'},
}

local function getScriptPath()
    local str = debug.getinfo(2, 'S').source:sub(2)

    return str:match('(.*/)')
end

ki.spoonPath = getScriptPath()

local statusDisplay = {
    DEFAULT_WIDTH = 75,
    DEFAULT_HEIGHT = 22,
    DEFAULT_FADE_TIMEOUT = 1.5,
    config = {
        normal = {
            text = modes.normal:upper(),
            backgroundColor = {
                alpha = 0.9,
                red = 180 / 255,
                blue = 180 / 255,
                green = 180 / 255,
            },
        },
        entity = {
            text = modes.entity:upper(),
            backgroundColor = {
                alpha = 0.9,
                red = 140 / 255,
                blue = 140 / 255,
                green = 200 / 255,
            },
        },
        action = {
            text = modes.action:upper(),
            backgroundColor = {
                alpha = 0.9,
                red = 255 / 255,
                blue = 180 / 255,
                green = 180 / 255,
            },
        },
    },
}

function statusDisplay:initStatusElements(options)
    return {
        {
            action = 'fill',
            type = 'rectangle',
            fillColor = options.backgroundColor,
        },
        {
            type = 'text',
            frame = { h = self.DEFAULT_HEIGHT, w = self.DEFAULT_WIDTH, x = 0, y = 0 },
            text = hs.styledtext.new(
                options.text,
                {
                    color = { red = 0.15, blue = 0.15, green = 0.15 },
                    font = { name = 'Menlo', size = 11.5 },
                    paragraphStyle = { alignment = 'center' },
                }
            ),
        },
    }
end

function statusDisplay:show(status)
    local options = self.config[status]
    local screenFrame = hs.window.focusedWindow():screen():frame()
    local dimensions = {
        x = screenFrame.x,
        y = screenFrame.y + screenFrame.h - statusDisplay.DEFAULT_HEIGHT,
        h = statusDisplay.DEFAULT_HEIGHT,
        w = statusDisplay.DEFAULT_WIDTH,
    }
    local statusElements = self:initStatusElements(options)
    local screenFrame = hs.window.focusedWindow():screen():frame()
    local statusDisplay = hs.canvas.new(dimensions):appendElements(statusElements):show()

    statusDisplay:delete(self.DEFAULT_FADE_TIMEOUT)
end

-- Event Triggers
ki.triggers = {
    [modes.normal] = {
        cmd = {
            escape = function() ki.state:enterTriggerMode() end,
        },
        ctrl = {
            space = function() ki.state:enterActionMode() end,
        },
    },
    [modes.entity] = {
        none = {
            escape = function() ki.state:exitMode() end,
        },
    },
    [modes.action] = {
        none = {
            escape = function() ki.state:exitMode() end,
        },
    },
}

-- Events
ki.events = {
    { name = 'enterTriggerMode', from = modes.normal, to = modes.entity },
    { name = 'enterActionMode', from = modes.normal, to = modes.action },
    { name = 'exitMode', from = modes.entity, to = modes.normal },
    { name = 'exitMode', from = modes.action, to = modes.normal },
}

-- Normal/Trigger/Action Mode Finite State Machine
local machine = dofile(ki.spoonPath..'/statemachine.lua')

ki.state = machine.create({
    initial = modes.normal,
    events = ki.events,
    callbacks = {
        onenterTriggerMode = function(self) statusDisplay:show(self.current) end,
        onenterActionMode = function(self) statusDisplay:show(self.current) end,
        onexitMode = function(self) statusDisplay:show(self.current) end,
    },
})

-- Keydown event listener and handler
ki.listener = hs.eventtap.new(
    { hs.eventtap.event.types.keyDown },
    function (event)
        local mode = ki.state.current
        local triggers = ki.triggers[ki.state.current]
        local eventFlags = event:getFlags()
        local modifierName = 'none'

      -- Determine modifier combination name
        for name, list in pairs(modifiers) do
            if eventFlags:containExactly(list) then
                modifierName = name
            end
        end

        local keyName = keyCodeMap[event:getKeyCode()]
        local trigger = triggers[modifierName] and triggers[modifierName][keyName]

        print(mode..' mode ', modifierName, keyName)

        if trigger then
            trigger()

            return true
        elseif mode ~= 'normal' then
            return true
        end
    end
)

-- Expose keydown listener start function
function ki:start()
    self.listener:start()
end

return ki
