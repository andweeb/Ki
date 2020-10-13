----------------------------------------------------------------------------------------------------
-- Volume entity
--
local Entity = spoon.Ki.Entity

-- Action to turn the system volume down by 10%
local function turnVolumeDown()
    local newVolume = hs.audiodevice.current().volume - 10
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
end

-- Action to turn the system volume up by 10%
local function turnVolumeUp()
    local newVolume = hs.audiodevice.current().volume + 10
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
end

-- Action to mute or unmute the system volume
local function toggleMute()
    local isMuted = hs.audiodevice.defaultOutputDevice():muted()
    hs.audiodevice.defaultOutputDevice():setMuted(not isMuted)
    return true
end

-- Helper method to create events that sets some system volume percentage
local function createVolumeToPercentageEvent(percentage)
    return function()
        hs.audiodevice.defaultOutputDevice():setVolume(percentage)
        return true
    end
end

local shortcuts = {
    { nil, "j", turnVolumeDown, { "Volume Control Mode", "Turn Volume Down" } },
    { nil, "k", turnVolumeUp, { "Volume Control Mode", "Turn Volume Up" } },
    { nil, "m", toggleMute, { "Volume Control Mode", "Mute or Unmute Volume" } },
}

-- Generate set volume events for each number (0-9 being 0% to 100%)
for number = 0, 9 do
    local percent = number * 100 / 9
    table.insert(shortcuts, {
        nil,
        tostring(number),
        createVolumeToPercentageEvent(percent),
        { "Volume Control Mode", "Set Volume to "..tostring(math.floor(percent)).."%" },
    })
end

return Entity {
    name = "Volume",
    shortcuts = shortcuts,
}
