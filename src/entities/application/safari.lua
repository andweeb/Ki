----------------------------------------------------------------------------------------------------
-- Safari application
--
local Application = spoon.Ki.Application
local Safari = Application:new("Safari")

Safari.addBookmark = Application.createMenuItemEvent("Add Bookmark...", { focusBefore = true })
Safari.openLocation = Application.createMenuItemEvent("Open Location...", { focusBefore = true })
Safari.moveTabToNewWindow = Application.createMenuItemEvent("Move Tab to New Window", { focusBefore = true })
Safari.mergeAllWindows = Application.createMenuItemEvent("Merge All Windows", { focusBefore = true })
Safari.openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
Safari.openNewPrivateWindow = Application.createMenuItemEvent("New Private Window", { focusAfter = true })
Safari.openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
Safari.openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
Safari.undoCloseTab = Application.createMenuItemEvent("Reopen Last Closed Tab", { focusBefore = true })
Safari.showHistory = Application.createMenuItemEvent("Show All History", { focusAfter = true })
Safari.showWebInspector = Application.createMenuItemEvent({ "Show Web Inspector", "Close Web Inspector" }, {
    isToggleable = true,
    focusBefore = true,
})

function Safari.createMediaEvent(command, errorMessage)
    return function (_, choice)
        local viewModel = {
            browser = "Safari",
            command = command,
            target = choice
                and "tab "..choice.tabIndex.." of window id "..choice.windowId
                or "front document",
            ["is-safari"] = true,
        }
        local script = Application.renderScriptTemplate("browser-media", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
        end
    end
end
Safari.toggleMute = Safari.createMediaEvent("toggle-mute", "Error (un)muting video")
Safari.toggleMedia = Safari.createMediaEvent("toggle-play", "Error toggling media")
Safari.nextMedia = Safari.createMediaEvent("next", "Error going to the next media")
Safari.previousMedia = Safari.createMediaEvent("previous", "Error going back to the previous media")
Safari.toggleCaptions = Safari.createMediaEvent("toggle-captions", "Error toggling captions")
Safari.skipMedia = Safari.createMediaEvent("skip", "Error skipping media")

function Safari.getSelectionItems()
    local choices = {}
    local script = Application.renderScriptTemplate("application-tab-titles", { application = "Safari" })
    local isOk, tabList, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error fetching browser tab information", rawTable.NSLocalizedFailureReason)

        return {}
    end

    local windowIndex = 0

    for windowId, titleList in pairs(tabList) do
        windowIndex = windowIndex + 1
        for tabIndex, tabTitle in pairs(titleList) do
            local lastOpenParenIndex = tabTitle:match("^.*()%(")
            local title = tabTitle:sub(1, lastOpenParenIndex - 1)
            local url = tabTitle:sub(lastOpenParenIndex - #tabTitle - 1):match("%((.-)%)") or ""

            table.insert(choices, {
                text = title,
                subText = "Window "..windowIndex.." Tab #"..tabIndex.." - "..url,
                tabIndex = tabIndex,
                windowIndex = windowIndex,
                windowId = windowId,
            })
        end
    end

    return choices
end

function Safari.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "front document"
    local script = Application.renderScriptTemplate("reload-safari", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
end

function Safari.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "current tab of front window" }
    local script = Application.renderScriptTemplate("close-safari", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error closing Safari tab", rawTable.NSLocalizedFailureReason)
    end
end

Safari:registerShortcuts({
    { nil, "d", Safari.addBookmark, { "Bookmarks", "Add bookmark" } },
    { nil, "i", Safari.showWebInspector, { "Develop", "Toggle Web Inspector" } },
    { nil, "l", Safari.openLocation, { "File", "Open Location..." } },
    { nil, "m", Safari.toggleMute, { "Media", "Toggle Mute" } },
    { nil, "n", Safari.openNewWindow, { "File", "Open New Window" } },
    { nil, "o", Safari.openFile, { "File", "Open File" } },
    { nil, "r", Safari.reload, { "View", "Reload Page" } },
    { nil, "t", Safari.openNewTab, { "File", "Open New Tab" } },
    { nil, "u", Safari.undoCloseTab, { "File", "Undo Close Tab" } },
    { nil, "w", Safari.close, { "File", "Close Tab/Window" } },
    { nil, "y", Safari.showHistory, { "History", "Show History" } },
    { nil, "space", Safari.toggleMedia, { "Media", "Play/Pause Media" } },
    { { "ctrl" }, "c", Safari.toggleCaptions, { "Media", "Toggle Media Captions" } },
    { { "ctrl" }, "n", Safari.nextMedia, { "Media", "Next Media" } },
    { { "ctrl" }, "p", Safari.previousMedia, { "Media", "Previous Media" } },
    { { "ctrl" }, "s", Safari.skipMedia, { "Media", "Skip Media" } },
    { { "cmd" }, "m", Safari.moveTabToNewWindow, { "Window", "Move Tab To New Window" } },
    { { "cmd", "shift" }, "m", Safari.mergeAllWindows, { "Window", "Merge All Windows" } },
    { { "shift" }, "n", Safari.openNewPrivateWindow, { "File", "Open New Private Window" } },
})

return Safari
