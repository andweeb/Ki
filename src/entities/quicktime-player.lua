local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    newAudioRecording = Application.createMenuItemEvent("New Audio Recording"),
    newMovieRecording = Application.createMenuItemEvent("New Movie Recording"),
    openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true }),
    openRecent = Application.createMenuItemSelectionEvent({ "File", "Open Recent" }, {
        focusAfter = true,
    }),
    newScreenRecording = Application.createMenuItemEvent("New Screen Recording"),
    trim = Application.createMenuItemEvent("Trim...", { focusBefore = true }),
    exportAs = Application.createMenuItemSelectionEvent({ "File", "Export As" }, {
        focusBefore = true,
    }),
}

function actions.togglePlay(_, choice)
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

function actions.toggleFileLoop(_, choice)
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

local shortcuts = {
    { nil, "a", actions.newAudioRecording, { "File", "New Audio Recording" } },
    { nil, "e", actions.exportAs, { "File", "Export As" } },
    { nil, "l", actions.toggleFileLoop, { "File", "Toggle File Loop Option" } },
    { nil, "m", actions.newMovieRecording, { "File", "New Movie Recording" } },
    { nil, "o", actions.openFile, { "File", "Open File..." } },
    { nil, "s", actions.newScreenRecording, { "File", "New Screen Recording" } },
    { nil, "t", actions.trim, { "File", "Trim..." } },
    { nil, "space", actions.togglePlay, { "Playback", "Toggle Play" } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
}

return Application:new("QuickTime Player", shortcuts), shortcuts, actions
