----------------------------------------------------------------------------------------------------
-- QuickTime Player application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newAudioRecording = Application.createMenuItemEvent("New Audio Recording")
local newMovieRecording = Application.createMenuItemEvent("New Movie Recording")
local openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
local openRecent = Application.createMenuItemChooserEvent({ "File", "Open Recent" }, { focusAfter = true })
local newScreenRecording = Application.createMenuItemEvent("New Screen Recording")
local trim = Application.createMenuItemEvent("Trim...", { focusBefore = true })
local exportAs = Application.createMenuItemChooserEvent({ "File", "Export As" }, { focusBefore = true })

-- Helper method to run AppleScript actions available in `osascripts/google-chrome.applescript`
local function runApplescriptAction(errorMessage, viewModel)
    local script = Application.renderScriptTemplate("quicktime-player", viewModel)
    local isOk, result, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end

    return result
end

-- Action to play or pause the frontmost or explicitly specified QuickTime Player video
local function togglePlay(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"

    runApplescriptAction("Error toggling play", {
        action = "toggle-play",
        target = target,
    })
end

-- Action to toggle the file loop status on the frontmost or explicitly specified QuickTime Player window
local function toggleFileLoop(_, choice)
    local target = choice
        and "document "..choice.windowIndex
        or "the first document"
    local isLooping = runApplescriptAction("Error toggling file loop", {
        action = "toggle-looping",
        target = target,
    })
    local toggleText = isLooping and "ON" or "OFF"

    hs.notify.show("Ki", "QuickTime Player", "Turned File Loop "..toggleText)
end

-- Register shortcuts with the actions initialized above
return Application {
    name = "QuickTimePlayer",
    shortcuts = {
        { nil, "a", newAudioRecording, { "File", "New Audio Recording" } },
        { nil, "e", exportAs, { "File", "Export As" } },
        { nil, "l", toggleFileLoop, { "File", "Toggle File Loop Option" } },
        { nil, "m", newMovieRecording, { "File", "New Movie Recording" } },
        { nil, "o", openFile, { "File", "Open File..." } },
        { nil, "s", newScreenRecording, { "File", "New Screen Recording" } },
        { nil, "t", trim, { "File", "Trim..." } },
        { nil, "space", togglePlay, { "Playback", "Toggle Play" } },
        { { "shift" }, "o", openRecent, { "File", "Open Recent" } },
    },
}
