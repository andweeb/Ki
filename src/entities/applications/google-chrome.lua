----------------------------------------------------------------------------------------------------
-- Google Chrome application
--
local Application = spoon.Ki.Application
local GoogleChrome = Application:new("Google Chrome")

-- Initialize menu item events
GoogleChrome.addBookmark = Application.createMenuItemEvent("Bookmark This Page...", {
   focusBefore = true,
   focusAfter = true,
})
GoogleChrome.showWebInspector = Application.createMenuItemEvent("Developer Tools", {
   focusBefore = true,
   focusAfter = true,
})
GoogleChrome.openLocation = Application.createMenuItemEvent("Open Location...", {
   focusBefore = true,
   focusAfter = true,
})
GoogleChrome.openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
GoogleChrome.openNewIncognitoWindow = Application.createMenuItemEvent("New Incognito Window", { focusAfter = true })
GoogleChrome.openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
GoogleChrome.openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
GoogleChrome.reopenClosedTab = Application.createMenuItemEvent("Reopen Closed Tab", { focusAfter = true })
GoogleChrome.showHistory = Application.createMenuItemEvent("Show Full History", { focusAfter = true })

-- Implement method to support selection of tab titles in select mode
function GoogleChrome.getSelectionItems()
    local choices = {}
    local script = Application.renderScriptTemplate("application-tabs", { application = "Google Chrome" })
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

-- Helper method to run AppleScript actions available in `osascripts/google-chrome.applescript`
function GoogleChrome:runApplescriptAction(errorMessage, viewModel)
    local script = self.renderScriptTemplate("google-chrome", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end
end

-- Action to focus a Google Chrome tab or window
function GoogleChrome.focus(app, choice)
    if choice then
        GoogleChrome:runApplescriptAction("Error focusing Google Chrome tab", {
            action = "focus-tab",
            windowId = choice.windowId,
            tabIndex = choice.tabIndex,
        })
    else
        Application.focus(app)
    end
end

-- Action to reload a Google Chrome tab or window
function GoogleChrome.reload(_, choice)
    local targetName = choice and "tab" or "window"
    local target = choice
        and "tab "..choice.tabIndex.." of window id "..choice.windowId
        or "front document"

    GoogleChrome:runApplescriptAction("Error reloading Google Chrome "..targetName, {
        action = "reload",
        target = target,
    })
end

-- Action to close a Google Chrome tab or window
function GoogleChrome.close(_, choice)
    local targetName = choice and "tab" or "window"
    local target = choice
        and "tab "..choice.tabIndex.." of window id "..choice.windowId
        or "front document"

    GoogleChrome:runApplescriptAction("Error closing Google Chrome "..targetName, {
        action = "close",
        target = target,
    })
end

-- Use a helper method to create various browser media actions
function GoogleChrome:createMediaAction(command, errorMessage)
    return function (_, choice)
        local viewModel = {
            browser = "Google Chrome",
            command = command,
            target = choice
                and "tab "..choice.tabIndex.." of window id "..choice.windowId
                or "front window's active tab",
            ["is-chrome"] = true,
        }
        local script = self.renderScriptTemplate("browser-media", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
        end
    end
end
GoogleChrome.toggleMute = GoogleChrome:createMediaAction("toggle-mute", "Error (un)muting media")
GoogleChrome.toggleMedia = GoogleChrome:createMediaAction("toggle-play", "Error toggling media")

-- Register shortcuts with the actions initialized above
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
