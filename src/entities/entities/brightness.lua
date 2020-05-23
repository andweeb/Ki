----------------------------------------------------------------------------------------------------
-- Brightness entity
--
local Entity = spoon.Ki.Entity
local Brightness = Entity:new("Brightness")

-- Action to lower the system brightness by 10%
function Brightness.lower()
    local newBrightness = hs.brightness.get() - 10
    hs.brightness.set(newBrightness)
end

-- Action to raise the system brightness by 10%
function Brightness.raise()
    local newBrightness = hs.brightness.get() + 10
    hs.brightness.set(newBrightness)
end

-- Helper method to create events that sets some system brightness percentage
function Brightness.createBrightnessToPercentageEvent(percentage)
    return function()
        hs.brightness.set(math.floor(percentage))
        return true
    end
end

local shortcuts = {
    { nil, "j", Brightness.lower, { "Brightness Control Mode", "Turn Brightness Down" } },
    { nil, "k", Brightness.raise, { "Brightness Control Mode", "Turn Brightness Up" } },
}

-- Generate set brightness events for each number (0-9 being 0% to 100%)
for number = 0, 9 do
    local percent = number * 100 / 9
    table.insert(shortcuts, {
        nil,
        tostring(number),
        Brightness.createBrightnessToPercentageEvent(percent),
        { "Brightness Control Mode", "Set Brightness to "..tostring(math.floor(percent)).."%" },
    })
end

Brightness:registerShortcuts(shortcuts, true)

return Brightness
