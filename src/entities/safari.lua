local Application = dofile(_G.spoonPath.."/application.lua")

local function createBrowserMediaEvent(command, errorMessage)
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

local actions = {
    addBookmark = Application.createMenuItemEvent("Add Bookmark...", { focusBefore = true }),
    showWebInspector = Application.createMenuItemEvent({ "Show Web Inspector", "Close Web Inspector" }, {
        isToggleable = true,
        focusBefore = true,
    }),
    openLocation = Application.createMenuItemEvent("Open Location...", { focusBefore = true }),
    moveTabToNewWindow = Application.createMenuItemEvent("Move Tab to New Window", { focusBefore = true }),
    mergeAllWindows = Application.createMenuItemEvent("Merge All Windows", { focusBefore = true }),
    openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true }),
    openNewPrivateWindow = Application.createMenuItemEvent("New Private Window", { focusAfter = true }),
    openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true }),
    openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true }),
    undoCloseTab = Application.createMenuItemEvent("Reopen Last Closed Tab", { focusBefore = true }),
    showHistory = Application.createMenuItemEvent("Show All History", { focusAfter = true }),
    toggleMute = createBrowserMediaEvent("toggle-mute", "Error (un)muting video"),
    toggleMedia = createBrowserMediaEvent("toggle-play", "Error toggling media"),
    nextMedia = createBrowserMediaEvent("next", "Error going to the next media"),
    previousMedia = createBrowserMediaEvent("previous", "Error going back to the previous media"),
    toggleCaptions = createBrowserMediaEvent("toggle-captions", "Error toggling captions"),
    skipMedia = createBrowserMediaEvent("skip", "Error skipping media"),
}

function Application.getSelectionItems()
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

function actions.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "front document"
    local script = Application.renderScriptTemplate("reload-safari", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
end

function actions.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "current tab of front window" }
    local script = Application.renderScriptTemplate("close-safari", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error closing Safari tab", rawTable.NSLocalizedFailureReason)
    end
end

local shortcuts = {
    { nil, "d", actions.addBookmark, { "Bookmarks", "Add bookmark" } },
    { nil, "i", actions.showWebInspector, { "Develop", "Toggle Web Inspector" } },
    { nil, "l", actions.openLocation, { "File", "Open Location..." } },
    { nil, "m", actions.toggleMute, { "Media", "Toggle Mute" } },
    { nil, "n", actions.openNewWindow, { "File", "Open New Window" } },
    { nil, "o", actions.openFile, { "File", "Open File" } },
    { nil, "r", actions.reload, { "View", "Reload Page" } },
    { nil, "t", actions.openNewTab, { "File", "Open New Tab" } },
    { nil, "u", actions.undoCloseTab, { "File", "Undo Close Tab" } },
    { nil, "w", actions.close, { "File", "Close Tab/Window" } },
    { nil, "y", actions.showHistory, { "History", "Show History" } },
    { nil, "space", actions.toggleMedia, { "Media", "Play/Pause Media" } },
    { { "ctrl" }, "c", actions.toggleCaptions, { "Media", "Toggle Media Captions" } },
    { { "ctrl" }, "n", actions.nextMedia, { "Media", "Next Media" } },
    { { "ctrl" }, "p", actions.previousMedia, { "Media", "Previous Media" } },
    { { "ctrl" }, "s", actions.skipMedia, { "Media", "Skip Media" } },
    { { "cmd" }, "m", actions.moveTabToNewWindow, { "Window", "Move Tab To New Window" } },
    { { "cmd", "shift" }, "m", actions.mergeAllWindows, { "Window", "Merge All Windows" } },
    { { "shift" }, "n", actions.openNewPrivateWindow, { "File", "Open New Private Window" } },
}

return Application:new("Safari", shortcuts), shortcuts, actions
