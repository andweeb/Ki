local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Safari = Entity:subclass("Safari")

function Safari.getSelectionItems()
    local choices = {}
    local script = Safari.renderScriptTemplate("application-tab-titles", { application = "Safari" })
    local isOk, tabList, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Safari.notifyError("Error fetching browser tab information", rawTable.NSLocalizedFailureReason)

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

function Safari.addBookmark(app, choice)
    Safari.focus(_, choice)
    app:selectMenuItem("Add Bookmark...")
    return true
end

function Safari.showWebInspector(app, choice)
    Safari.focus(_, choice)
    _ = app:selectMenuItem("Show Web Inspector") or app:selectMenuItem("Close Web Inspector")
    return true
end

function Safari.openLocation(app, choice)
    Safari.focus(_, choice)
    app:selectMenuItem("Open Location...")
    return true
end

function Safari.toggleMute(_, choice)
    local viewModel = {
        browser = "Safari",
        command = "toggle-mute",
        target = choice
            and "tab "..choice.tabIndex.." of window id "..choice.windowId
            or "front document",
        ["is-safari"] = true,
    }
    local script = Safari.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Safari.notifyError("Error (un)muting video", rawTable.NSLocalizedFailureReason)
    end
end

function Safari.moveTabToNewWindow(app, choice)
    Entity.focus(app, choice)
    app:selectMenuItem("Move Tab to New Window")
    return true
end

function Safari.mergeAllWindows(app)
    Safari.focus(app)
    app:selectMenuItem("Merge All Windows")
    return true
end

function Safari.openNewWindow(app)
    app:selectMenuItem("New Window")
    return true
end

function Safari.openNewPrivateWindow(app)
    app:selectMenuItem("New Private Window")
    return true
end

function Safari.openFile(app)
    app:selectMenuItem("Open File...")
    return true
end

function Safari.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "front document"
    local script = Safari.renderScriptTemplate("reload-safari", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Safari.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
end

function Safari.openNewTab(app)
    app:selectMenuItem("New Tab")
    return true
end

function Safari.toggleMedia(_, choice)
    local viewModel = {
        browser = "Safari",
        command = "toggle-play",
        target = choice
            and "tab "..choice.tabIndex.." of window id "..choice.windowId
            or "front document",
        ["is-safari"] = true,
    }
    local script = Safari.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Safari.notifyError("Error toggling media", rawTable.NSLocalizedFailureReason)
    end
end

function Safari.undoCloseTab(app)
    app:selectMenuItem("Reopen Last Closed Tab")
end

function Safari.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "current tab of front window" }
    local script = Safari.renderScriptTemplate("close-safari", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Safari.notifyError("Error closing Safari tab", rawTable.NSLocalizedFailureReason)
    end
end

function Safari.showHistory(app, choice)
    Safari.focus(_, choice)
    app:selectMenuItem("Show All History")
end

function Safari:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "d", self.addBookmark, { "Bookmarks", "Add bookmark" } },
        { nil, "i", self.showWebInspector, { "Develop", "Toggle Web Inspector" } },
        { nil, "l", self.openLocation, { "File", "Open Location..." } },
        { nil, "m", self.toggleMute, { "Media", "Toggle Mute" } },
        { { "cmd" }, "m", self.moveTabToNewWindow, { "Window", "Move Tab To New Window" } },
        { { "cmd", "shift" }, "m", self.mergeAllWindows, { "Window", "Merge All Windows" } },
        { nil, "n", self.openNewWindow, { "File", "Open New Window" } },
        { { "shift" }, "n", self.openNewPrivateWindow, { "File", "Open New Private Window" } },
        { nil, "o", self.openFile, { "File", "Open File" } },
        { nil, "r", self.reload, { "View", "Reload Page" } },
        { nil, "t", self.openNewTab, { "File", "Open New Tab" } },
        { nil, "u", self.undoCloseTab, { "File", "Undo Close Tab" } },
        { nil, "w", self.close, { "File", "Close Tab/Window" } },
        { nil, "y", self.showHistory, { "History", "Show History" } },
        { nil, "space", self.toggleMedia, { "Media", "Play/Pause Media" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Safari", shortcuts)
end

return Safari
