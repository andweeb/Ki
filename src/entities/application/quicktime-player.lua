----------------------------------------------------------------------------------------------------
-- QuickTime Player application
--
local Application = spoon.Ki.Application
local QuickTimePlayer = Application:new("QuickTime Player")

QuickTimePlayer.newAudioRecording = Application.createMenuItemEvent("New Audio Recording")
QuickTimePlayer.newMovieRecording = Application.createMenuItemEvent("New Movie Recording")
QuickTimePlayer.openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
QuickTimePlayer.openRecent = Application.createMenuItemSelectionEvent({ "File", "Open Recent" }, { focusAfter = true })
QuickTimePlayer.newScreenRecording = Application.createMenuItemEvent("New Screen Recording")
QuickTimePlayer.trim = Application.createMenuItemEvent("Trim...", { focusBefore = true })
QuickTimePlayer.exportAs = Application.createMenuItemSelectionEvent({ "File", "Export As" }, { focusBefore = true })

function QuickTimePlayer.togglePlay(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"
    local script = Application.renderScriptTemplate("quicktime-player", {
        option = "toggle-play",
        target = target,
    })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error toggling play", rawTable.NSLocalizedFailureReason)
    end
end

function QuickTimePlayer.toggleFileLoop(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"
    local script = Application.renderScriptTemplate("quicktime-player", {
        option = "toggle-looping",
        target = target,
    })
    local isOk, isLooping, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error toggling file loop option", rawTable.NSLocalizedFailureReason)
    end

    local toggleText = isLooping and "ON" or "OFF"

    hs.notify.show("Ki", "QuickTime Player", "Turned File Loop option"..toggleText)
end

QuickTimePlayer:registerShortcuts({
    { nil, "a", QuickTimePlayer.newAudioRecording, { "File", "New Audio Recording" } },
    { nil, "e", QuickTimePlayer.exportAs, { "File", "Export As" } },
    { nil, "l", QuickTimePlayer.toggleFileLoop, { "File", "Toggle File Loop Option" } },
    { nil, "m", QuickTimePlayer.newMovieRecording, { "File", "New Movie Recording" } },
    { nil, "o", QuickTimePlayer.openFile, { "File", "Open File..." } },
    { nil, "s", QuickTimePlayer.newScreenRecording, { "File", "New Screen Recording" } },
    { nil, "t", QuickTimePlayer.trim, { "File", "Trim..." } },
    { nil, "space", QuickTimePlayer.togglePlay, { "Playback", "Toggle Play" } },
    { { "shift" }, "o", QuickTimePlayer.openRecent, { "File", "Open Recent" } },
})

return QuickTimePlayer
