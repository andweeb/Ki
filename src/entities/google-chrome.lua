local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local GoogleChrome = Entity:subclass("GoogleChrome")

function GoogleChrome.focus(app, choice)
    if choice then
        local viewModel = { target = "window id "..choice.windowId.." to "..choice.tabIndex }
        local script = GoogleChrome.renderScriptTemplate("focus-chrome-tab", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            GoogleChrome.notifyError("Error activating Google Chrome tab", rawTable.NSLocalizedFailureReason)
        end
    end

    Entity.focus(app)
end

function GoogleChrome.getSelectionItems()
    local choices = {}
    local script = GoogleChrome.renderScriptTemplate("application-tab-titles", { application = "Google Chrome" })
    local isOk, tabList, rawTable = hs.osascript.applescript(script)

    if not isOk then
        GoogleChrome.notifyError("Error fetching browser tab information", rawTable.NSLocalizedFailureReason)

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

function GoogleChrome.addBookmark(app, choice)
    GoogleChrome.focus(app, choice)
    app:selectMenuItem("Bookmark This Page...")
    return true
end

function GoogleChrome.showWebInspector(app, choice)
    GoogleChrome.focus(app, choice)
    app:selectMenuItem("Developer Tools")
    return true
end

function GoogleChrome.openLocation(app, choice)
    GoogleChrome.focus(app, choice)
    app:selectMenuItem("Open Location...")
    return true
end

function GoogleChrome.toggleMute(_, choice)
    local viewModel = {
        browser = "GoogleChrome",
        command = "toggle-mute",
        target = choice
            and "tab "..choice.tabIndex.." of window id "..choice.windowId
            or "front document",
        ["is-safari"] = true,
    }
    local script = GoogleChrome.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        GoogleChrome.notifyError("Error (un)muting video", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.openNewWindow(app)
    app:selectMenuItem("New Window")
    return true
end

function GoogleChrome.openNewPrivateWindow(app)
    app:selectMenuItem("New Incognito Window")
    return true
end

function GoogleChrome.openFile(app)
    app:selectMenuItem("Open File...")
    return true
end

function GoogleChrome.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "active tab of first window"
    local script = GoogleChrome.renderScriptTemplate("reload-chrome", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        GoogleChrome.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.openNewTab(app)
    app:selectMenuItem("New Tab")
    return true
end

function GoogleChrome.toggleMedia(_, choice)
    local viewModel = {
        browser = "Google Chrome",
        command = "toggle-play",
        target = choice
            and "tab "..choice.tabIndex.." of window id "..choice.windowId
            or "front window's active tab",
        ["is-chrome"] = true,
    }
    local script = GoogleChrome.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        GoogleChrome.notifyError("Error toggling media", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.undoCloseTab(app)
    app:selectMenuItem("Reopen Closed Tab")
end

function GoogleChrome.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "active tab of first window" }
    local script = GoogleChrome.renderScriptTemplate("close-chrome", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        GoogleChrome.notifyError("Error closing Google Chrome window or tab", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.showHistory(app)
    app:selectMenuItem("Show Full History")
end

function GoogleChrome:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "d", self.addBookmark, { "Bookmarks", "Bookmark This Page..." } },
        { nil, "i", self.showWebInspector, { "Developer", "Toggle Web Inspector" } },
        { nil, "l", self.openLocation, { "File", "Open Location..." } },
        { nil, "m", self.toggleMute, { "Media", "Toggle Mute" } },
        { nil, "n", self.openNewWindow, { "File", "New Window" } },
        { { "shift" }, "n", self.openNewPrivateWindow, { "File", "New Incognito Window" } },
        { nil, "o", self.openFile, { "File", "Open File" } },
        { nil, "r", self.reload, { "View", "Reload This Page" } },
        { nil, "t", self.openNewTab, { "File", "New Tab" } },
        { nil, "u", self.undoCloseTab, { "File", "Reopen Closed Tab" } },
        { nil, "w", self.close, { "File", "Close Tab/Window" } },
        { nil, "y", self.showHistory, { "History", "Show History" } },
        { nil, "space", self.toggleMedia, { "Media", "Play/Pause Media" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Google Chrome", shortcuts)
end

return GoogleChrome
