----------------------------------------------------------------------------------------------------
-- Volume entity
--
local Entity = spoon.Ki.Entity
local Volume = Entity:new("Volume")

function Volume.turnVolumeDown()
    local newVolume = hs.audiodevice.current().volume - 10
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
end

function Volume.turnVolumeUp()
    local newVolume = hs.audiodevice.current().volume + 10
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
end

function Volume.toggleMute()
    local isMuted = hs.audiodevice.defaultOutputDevice():muted()
    hs.audiodevice.defaultOutputDevice():setMuted(isMuted)
    return true
end

Volume:registerShortcuts({
    { nil, "j", Volume.turnVolumeDown, { "Volume Control Mode", "Turn Volume Down" } },
    { nil, "k", Volume.turnVolumeUp, { "Volume Control Mode", "Turn Volume Up" } },
    { nil, "m", Volume.toggleMute, { "Volume Control Mode", "Mute or Unmute Volume" } },
}, true)

function Volume.createVolumeToPercentageEvent(percentage)
    return function()
        hs.audiodevice.defaultOutputDevice():setVolume(percentage)
        return true
    end
end

for number = 0, 9 do
    local percent = number * 100 / 9
    table.insert(Volume.shortcuts, {
        nil,
        tostring(number),
        Volume.createVolumeToPercentageEvent(percent),
        { "Volume Control Mode", "Set Volume to "..tostring(math.floor(percent)).."%" },
    })
end

return Volume
