----------------------------------------------------------------------------------------------------
-- QuickTime Player application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newAudioRecording = Application:createMenuItemAction("New Audio Recording")
local newMovieRecording = Application:createMenuItemAction("New Movie Recording")
local openFile = Application:createMenuItemAction("Open File...", { focusAfter = true })
local openRecent = Application:createChooseMenuItemAction({ "File", "Open Recent" }, { focusAfter = true })
local newScreenRecording = Application:createMenuItemAction("New Screen Recording")
local trim = Application:createMenuItemAction("Trim...", { focusBefore = true })
local exportAs = Application:createChooseMenuItemAction({ "File", "Export As" }, { focusBefore = true })

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
    name = "QuickTime Player",
    shortcuts = {
        { nil, "a", newAudioRecording, "New Audio Recording" },
        { nil, "e", exportAs, "Export As" },
        { nil, "l", toggleFileLoop, "Toggle File Loop Option" },
        { nil, "m", newMovieRecording, "New Movie Recording" },
        { nil, "o", openFile, "Open File..." },
        { nil, "s", newScreenRecording, "New Screen Recording" },
        { nil, "t", trim, "Trim..." },
        { nil, "space", togglePlay, "Toggle Play" },
        { { "shift" }, "o", openRecent, "Open Recent" },
    },
}
