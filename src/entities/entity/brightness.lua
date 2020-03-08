----------------------------------------------------------------------------------------------------
-- Brightness entity
--
local Entity = spoon.Ki.Entity
local Brightness = Entity:new("Brightness")

function Brightness.lower()
    local newBrightness = hs.brightness.get() - 10
    hs.brightness.set(newBrightness)
end

function Brightness.raise()
    local newBrightness = hs.brightness.get() + 10
    hs.brightness.set(newBrightness)
end

local function createBrightnessToPercentageEvent(percentage)
    return function()
        hs.brightness.set(math.floor(percentage))
        return true
    end
end

Brightness:registerShortcuts({
    { nil, "j", Brightness.lower, { "Brightness Control Mode", "Turn Brightness Down" } },
    { nil, "k", Brightness.raise, { "Brightness Control Mode", "Turn Brightness Up" } },
}, true)

for number = 0, 9 do
    local percent = number * 100 / 9
    table.insert(Brightness.shortcuts, {
        nil,
        tostring(number),
        createBrightnessToPercentageEvent(percent),
        { "Brightness Control Mode", "Set Brightness to "..tostring(math.floor(percent)).."%" },
    })
end

return Brightness
