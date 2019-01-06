local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
   addBookmark = Application.createMenuItemEvent("Bookmark This Page...", {
       focusBefore = true,
       focusAfter = true,
   }),
   showWebInspector = Application.createMenuItemEvent("Developer Tools", {
       focusBefore = true,
       focusAfter = true,
   }),
   openLocation = Application.createMenuItemEvent("Open Location...", {
       focusBefore = true,
       focusAfter = true,
   }),
   openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true }),
   openNewIncognitoWindow = Application.createMenuItemEvent("New Incognito Window", { focusAfter = true }),
   openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true }),
   openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true }),
   reopenClosedTab = Application.createMenuItemEvent("Reopen Closed Tab", { focusAfter = true }),
   showHistory = Application.createMenuItemEvent("Show Full History", { focusAfter = true }),
}

function Application.getSelectionItems()
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

function actions.focus(app, choice)
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

function actions.toggleMute(_, choice)
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

function actions.reload(_, choice)
    local target = choice
        and "tab "..choice.tabIndex.." of front window"
        or "active tab of first window"
    local script = Application.renderScriptTemplate("reload-chrome", { target = target })
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error reloading active window", rawTable.NSLocalizedFailureReason)
    end
end

function actions.toggleMedia(_, choice)
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

function actions.close(_, choice)
    local viewModel = choice
        and { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
        or { target = "active tab of first window" }
    local script = Application.renderScriptTemplate("close-chrome", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error closing Google Chrome window or tab", rawTable.NSLocalizedFailureReason)
    end
end

local shortcuts = {
    { nil, nil, actions.focus, { "Google Chrome", "Activate/Focus" } },
    { nil, "d", actions.addBookmark, { "Bookmarks", "Bookmark This Page..." } },
    { nil, "i", actions.showWebInspector, { "Developer", "Toggle Web Inspector" } },
    { nil, "l", actions.openLocation, { "File", "Open Location..." } },
    { nil, "m", actions.toggleMute, { "Media", "Toggle Mute" } },
    { nil, "n", actions.openNewWindow, { "File", "New Window" } },
    { { "shift" }, "n", actions.openNewIncognitoWindow, { "File", "New Incognito Window" } },
    { nil, "o", actions.openFile, { "File", "Open File" } },
    { nil, "r", actions.reload, { "View", "Reload This Page" } },
    { nil, "t", actions.openNewTab, { "File", "New Tab" } },
    { nil, "u", actions.reopenClosedTab, { "File", "Reopen Closed Tab" } },
    { nil, "w", actions.close, { "File", "Close Tab/Window" } },
    { nil, "y", actions.showHistory, { "History", "Show History" } },
    { nil, "space", actions.toggleMedia, { "Media", "Play/Pause Media" } },
}

return Application:new("Google Chrome", shortcuts), shortcuts, actions
