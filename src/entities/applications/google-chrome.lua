----------------------------------------------------------------------------------------------------
-- Google Chrome application
--
local Ki = spoon.Ki
local Website = Ki.Website
local Application = Ki.Application

-- Initialize menu item events
local addBookmark = Application.createMenuItemEvent("Bookmark This Page...", {
   focusBefore = true,
   focusAfter = true,
})
local showWebInspector = Application.createMenuItemEvent("Developer Tools", {
   focusBefore = true,
   focusAfter = true,
})
local openLocation = Application.createMenuItemEvent("Open Location...", {
   focusBefore = true,
   focusAfter = true,
})
local openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
local openNewIncognitoWindow = Application.createMenuItemEvent("New Incognito Window", { focusAfter = true })
local openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
local openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
local reopenClosedTab = Application.createMenuItemEvent("Reopen Closed Tab", { focusAfter = true })
local showHistory = Application.createMenuItemEvent("Show Full History", { focusAfter = true })

-- Implement method to support selection of tab titles in select mode
local function getChooserItems()
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
                imageURL = Website:getFaviconURL(url),
            })
        end
    end

    return choices
end

-- Helper method to run AppleScript actions available in `osascripts/google-chrome.applescript`
local function runApplescriptAction(errorMessage, viewModel)
    local script = Application.renderScriptTemplate("google-chrome", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end
end

-- Action to focus a Google Chrome tab or window
local function focus(app, choice)
    if choice then
        runApplescriptAction("Error focusing Google Chrome tab", {
            action = "focus-tab",
            windowId = choice.windowId,
            tabIndex = choice.tabIndex,
        })
    else
        Application.focus(app)
    end
end

-- Action to reload a Google Chrome tab or window
local function reload(_, choice)
    local targetName = choice and "tab" or "window"
    local target = choice
        and "tab "..choice.tabIndex.." of window id "..choice.windowId
        or "front document"

    runApplescriptAction("Error reloading Google Chrome "..targetName, {
        action = "reload",
        target = target,
    })
end

-- Action to close a Google Chrome tab or window
local function close(_, choice)
    local targetName = choice and "tab" or "window"
    local target = choice
        and "tab "..choice.tabIndex.." of window id "..choice.windowId
        or "front document"

    runApplescriptAction("Error closing Google Chrome "..targetName, {
        action = "close",
        target = target,
    })
end

-- Use a helper method to create various browser media actions
local function createMediaAction(command, errorMessage)
    return function (_, choice)
        local viewModel = {
            browser = "Google Chrome",
            command = command,
            target = choice
                and "tab "..choice.tabIndex.." of window id "..choice.windowId
                or "front window's active tab",
            ["is-chrome"] = true,
        }
        local script = Application.renderScriptTemplate("browser-media", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
        end
    end
end
local toggleMute = createMediaAction("toggle-mute", "Error (un)muting media")
local toggleMedia = createMediaAction("toggle-play", "Error toggling media")

-- Register shortcuts with the actions initialized above
return {
    name = "Google Chrome",
    getChooserItems = getChooserItems,
    shortcuts = {
        { nil, nil, focus, { "Google Chrome", "Activate" } },
        { nil, "d", addBookmark, { "Bookmarks", "Bookmark This Page..." } },
        { nil, "i", showWebInspector, { "Developer", "Toggle Web Inspector" } },
        { nil, "l", openLocation, { "File", "Open Location..." } },
        { nil, "m", toggleMute, { "Media", "Toggle Mute" } },
        { nil, "n", openNewWindow, { "File", "New Window" } },
        { nil, "o", openFile, { "File", "Open File" } },
        { nil, "r", reload, { "View", "Reload This Page" } },
        { nil, "t", openNewTab, { "File", "New Tab" } },
        { nil, "u", reopenClosedTab, { "File", "Reopen Closed Tab" } },
        { nil, "w", close, { "File", "Close Tab/Window" } },
        { nil, "y", showHistory, { "History", "Show History" } },
        { nil, "space", toggleMedia, { "Media", "Play/Pause Media" } },
        { { "shift" }, "n", openNewIncognitoWindow, { "File", "New Incognito Window" } },
    },
}
