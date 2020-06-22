----------------------------------------------------------------------------------------------------
-- QuickTime Player application
--
local Application = spoon.Ki.Application
local QuickTimePlayer = Application:new("QuickTime Player")

-- Initialize menu item events
QuickTimePlayer.newAudioRecording = Application.createMenuItemEvent("New Audio Recording")
QuickTimePlayer.newMovieRecording = Application.createMenuItemEvent("New Movie Recording")
QuickTimePlayer.openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
QuickTimePlayer.openRecent = Application.createMenuItemChooserEvent({ "File", "Open Recent" }, { focusAfter = true })
QuickTimePlayer.newScreenRecording = Application.createMenuItemEvent("New Screen Recording")
QuickTimePlayer.trim = Application.createMenuItemEvent("Trim...", { focusBefore = true })
QuickTimePlayer.exportAs = Application.createMenuItemChooserEvent({ "File", "Export As" }, { focusBefore = true })

-- Helper method to run AppleScript actions available in `osascripts/google-chrome.applescript`
function QuickTimePlayer:runApplescriptAction(errorMessage, viewModel)
    local script = self.renderScriptTemplate("quicktime-player", viewModel)
    local isOk, result, rawTable = hs.osascript.applescript(script)

    if not isOk then
        self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end

    return result
end

-- Action to play or pause the frontmost or explicitly specified QuickTime Player video
function QuickTimePlayer.togglePlay(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"

    QuickTimePlayer:runApplescriptAction("Error toggling play", {
        action = "toggle-play",
        target = target,
    })
end

-- Action to toggle the file loop status on the frontmost or explicitly specified QuickTime Player window
function QuickTimePlayer.toggleFileLoop(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"
    local isLooping = QuickTimePlayer:runApplescriptAction("Error toggling file loop", {
        action = "toggle-looping",
        target = target,
    })
    local toggleText = isLooping and "ON" or "OFF"

    hs.notify.show("Ki", "QuickTime Player", "Turned File Loop "..toggleText)
end

-- Register shortcuts with the actions initialized above
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
