----------------------------------------------------------------------------------------------------
-- Brightness entity
--
local Ki = spoon.Ki
local Entity = Ki.Entity

-- Action to lower the system brightness by 10%
local function lowerBrightness()
    local newBrightness = hs.brightness.get() - 10
    hs.brightness.set(newBrightness)
end

-- Action to raise the system brightness by 10%
local function raiseBrightness()
    local newBrightness = hs.brightness.get() + 10
    hs.brightness.set(newBrightness)
end

-- Action creator for actions that set a specific system brightness percentage
local function brightnessToPercent(percentage)
    return function()
        hs.brightness.set(math.floor(percentage))
        return true
    end
end

local shortcuts = {
    { nil, "j", lowerBrightness, "Lower Brightness" },
    { nil, "k", raiseBrightness, "Raise Brightness" },
}

-- Generate set brightness events for each number (0-9 being 0% to 100%)
for number = 0, 9 do
    local percent = number * 100 / 9
    table.insert(shortcuts, {
        nil,
        tostring(number),
        brightnessToPercent(percent),
        "Set Brightness to "..tostring(math.floor(percent)).."%",
    })
end

return Entity {
    name = "Brightness",
    shortcuts = shortcuts
}
