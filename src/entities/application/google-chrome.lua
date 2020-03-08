----------------------------------------------------------------------------------------------------
-- Google Chrome application
--
local Application = spoon.Ki.Application
local GoogleChrome = Application:new("Google Chrome")

local focusAfter = { focusAfter = true }
local focusBeforeAfter = {
   focusBefore = true,
   focusAfter = true,
}
GoogleChrome.addBookmark = Application.createMenuItemEvent("Bookmark This Page...", focusBeforeAfter)
GoogleChrome.showWebInspector = Application.createMenuItemEvent("Developer Tools", focusBeforeAfter)
GoogleChrome.openLocation = Application.createMenuItemEvent("Open Location...", focusBeforeAfter)
GoogleChrome.openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
GoogleChrome.openNewIncognitoWindow = Application.createMenuItemEvent("New Incognito Window", focusAfter)
GoogleChrome.openFile = Application.createMenuItemEvent("Open File...", focusAfter)
GoogleChrome.openNewTab = Application.createMenuItemEvent("New Tab", focusAfter)
GoogleChrome.reopenClosedTab = Application.createMenuItemEvent("Reopen Closed Tab", focusAfter)
GoogleChrome.showHistory = Application.createMenuItemEvent("Show Full History", focusAfter)

function GoogleChrome.getSelectionItems()
    local choices = {}
    local script = Application.renderScriptTemplate("application-tab-titles", { application = "Google Chrome" })
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

function GoogleChrome.focus(app, choice)
    if choice then
        local viewModel = { target = "window id "..choice.windowId.." to "..choice.tabIndex }
        local script = Application.renderScriptTemplate("focus-chrome-tab", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError("Error activating Google Chrome tab", rawTable.NSLocalizedFailureReason)
        end
    end

    Application.focus(app)
end

function GoogleChrome.toggleMute(_, choice)
    local viewModel = {
        browser = "GoogleChrome",
        command = "toggle-mute",
        target = choice
            and "tab "..choice.tabIndex.." of window id "..choice.windowId
            or "front document",
        ["is-chrome"] = true,
    }
    local script = Application.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error (un)muting video", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "active tab of first window"
    local script = Application.renderScriptTemplate("reload-chrome", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
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
    local script = Application.renderScriptTemplate("browser-media", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error toggling media", rawTable.NSLocalizedFailureReason)
    end
end

function GoogleChrome.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "active tab of first window" }
    local script = Application.renderScriptTemplate("close-chrome", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error closing Google Chrome window or tab", rawTable.NSLocalizedFailureReason)
    end
end

GoogleChrome:registerShortcuts({
    { nil, nil, GoogleChrome.focus, { "Google Chrome", "Activate/Focus" } },
    { nil, "d", GoogleChrome.addBookmark, { "Bookmarks", "Bookmark This Page..." } },
    { nil, "i", GoogleChrome.showWebInspector, { "Developer", "Toggle Web Inspector" } },
    { nil, "l", GoogleChrome.openLocation, { "File", "Open Location..." } },
    { nil, "m", GoogleChrome.toggleMute, { "Media", "Toggle Mute" } },
    { nil, "n", GoogleChrome.openNewWindow, { "File", "New Window" } },
    { nil, "o", GoogleChrome.openFile, { "File", "Open File" } },
    { nil, "r", GoogleChrome.reload, { "View", "Reload This Page" } },
    { nil, "t", GoogleChrome.openNewTab, { "File", "New Tab" } },
    { nil, "u", GoogleChrome.reopenClosedTab, { "File", "Reopen Closed Tab" } },
    { nil, "w", GoogleChrome.close, { "File", "Close Tab/Window" } },
    { nil, "y", GoogleChrome.showHistory, { "History", "Show History" } },
    { nil, "space", GoogleChrome.toggleMedia, { "Media", "Play/Pause Media" } },
    { { "shift" }, "n", GoogleChrome.openNewIncognitoWindow, { "File", "New Incognito Window" } },
})

return GoogleChrome
