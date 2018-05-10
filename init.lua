--- === Ki ===
---
--- macOS macros with composable commands
---

local ki = {}
ki.__index = ki

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
    return debug.getinfo(2, 'S').source:sub(2):match('(.*/)')
end

local spoonPath = getScriptPath()

-- Normal/Trigger/Action Mode Finite State Machine
local machine = dofile(spoonPath..'/statemachine.lua')

--- Ki.statusDisplay
--- Variable
---
--- A table that defines the behavior for displaying the status on mode transition changes. The `show` function should initially clear out existing displays and display the transitioned mode.
---  * `show` - A function invoked when a mode transition event occurs, with the following argument:
---    * `status` - a string value containing the current mode of the finite state machine (i.e., "normal", "entity", etc.)
---
--- Defaults to a simple text display in the center of the menu bar of the focused screen.
ki.statusDisplay = nil

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

-- Transition events
local transitionEvents = {
    { name = 'enterTriggerMode', from = modes.normal, to = modes.entity },
    { name = 'enterActionMode', from = modes.normal, to = modes.action },
    { name = 'exitMode', from = modes.entity, to = modes.normal },
    { name = 'exitMode', from = modes.action, to = modes.normal },
}

-- Initialize transition status display callbacks with mode transition events
function createStatusDisplayCallbacks(events)
    local callbacks = {}

    -- Set event callbacks with auto-hide on entering normal mode
    for _, event in pairs(events) do
        local eventName = 'on'..event.name

        if not callbacks[eventName] then
            callbacks[eventName] = function(self)
                ki.statusDisplay:show(self.current, event.to == modes.normal)
            end
        end
    end

    return callbacks
end

ki.events = transitionEvents

ki.state = machine.create({
    initial = modes.normal,
    events = ki.events,
    callbacks = createStatusDisplayCallbacks(transitionEvents),
})

-- Keydown event listener and handler
ki.listener = hs.eventtap.new(
    { hs.eventtap.event.types.keyDown },
    function (event)
        local mode = ki.state.current
        local triggers = ki.triggers[ki.state.current]
        local eventFlags = event:getFlags()

        -- Determine modifier combination key
        local modifierName = 'none'
        for name, list in pairs(modifiers) do
            if eventFlags:containExactly(list) then
                modifierName = name
            end
        end

        local keyName = keyCodeMap[event:getKeyCode()]
        local trigger = triggers[modifierName] and triggers[modifierName][keyName]

        print('-- '..mode:upper()..' -- { '..modifierName..' + '..keyName..' }')

        -- Avoid propagation on existing trigger or non-existent trigger in a non-normal mode
        if trigger then
            trigger()
            return true
        elseif mode ~= 'normal' then
            return true
        end

        -- Propagate event in normal mode
    end
)

function ki:start()
    -- Set default status display if not provided
    self.statusDisplay = self.statusDisplay or dofile(spoonPath..'/status-display.lua')

    -- Set transition events

    -- Set trigger events
    -- Print overwritten default triggers

    -- Start keydown event listener
    self.listener:start()
end

return ki
