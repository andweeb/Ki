----------------------------------------------------------------------------------------------------
-- Safari application
--
local Application = spoon.Ki.Application
local Safari = Application:new("Safari")

-- Initialize menu item events
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

-- Use a helper method to create various media actions
function Safari:createMediaAction(command, errorMessage)
    return function (_, choice)
        local viewModel = {
            browser = "Safari",
            command = command,
            target = choice
                and "tab "..choice.tabIndex.." of window id "..choice.windowId
                or "front document",
            ["is-safari"] = true,
        }
        local script = self.renderScriptTemplate("browser-media", viewModel)
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
        end
    end
end
Safari.toggleMute = Safari:createMediaAction("toggle-mute", "Error (un)muting video")
Safari.toggleMedia = Safari:createMediaAction("toggle-play", "Error toggling media")
Safari.nextMedia = Safari:createMediaAction("next", "Error going to the next media")
Safari.previousMedia = Safari:createMediaAction("previous", "Error going back to the previous media")
Safari.toggleCaptions = Safari:createMediaAction("toggle-captions", "Error toggling captions")
Safari.skipMedia = Safari:createMediaAction("skip", "Error skipping media")

-- Implement method to support selection of tab titles in select mode
function Safari.getChooserItems()
    local choices = {}
    local script = Application.renderScriptTemplate("application-tabs", { application = "Safari" })
    local isOk, tabList, rawTable = hs.osascript.applescript(script)

    if not isOk then
        local errorMessage = "Error fetching browser tab information"
        Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
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

-- Helper method to run AppleScript actions available in `osascripts/safari.applescript`
function Safari:runApplescriptAction(errorMessage, viewModel)
    local script = self.renderScriptTemplate("safari", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end
end

-- Action to reload a Safari tab or window
function Safari:reload(_, choice)
    local viewModel = {
        action = "reload",
        target = "front document",
    }

    if choice then
        viewModel.target = "tab "..choice.tabIndex.." of window id "..choice.windowId
    end

    self:runApplescriptAction("Error reloading Safari tab", viewModel)
end

-- Action to close a Safari tab or window
function Safari:close(_, choice)
    local viewModel = {
        action = "close",
        target = "current tab of front window",
    }

    if choice then
        viewModel.target = "tab "..choice.tabIndex.." of window id "..choice.windowId
    end

    self:runApplescriptAction("Error closing Safari tab", viewModel)
end

-- Action to focus a Safari tab for some window id
function Safari:focusTab(windowId, tabIndex)
    self:runApplescriptAction("Error focusing Safari tab", {
        action = "focus-tab",
        windowId = windowId,
        tabIndex = tabIndex,
    })
end

-- Action to focus a Safari tab or window
--
-- Override `Application.focus` since there has been a `hs.window:focusTab` issue for
-- Safari after the v10.14.3 macOS update: https://github.com/Hammerspoon/hammerspoon/issues/2080
function Safari:focus(app, choice)
    if choice then
        local windowId = choice.windowId
        local tabIndex = choice.tabIndex

        if tabIndex then
            self:focusTab(windowId, tabIndex)
        end

        local window = hs.window(tonumber(windowId))
        if windowId and window then
            window:focus()
        end
    elseif app then
        app:activate()
    end
end

Safari:registerShortcuts({
    { nil, nil, function(...) Safari:focus(...) end, { "Safari", "Activate" } },
    { nil, "d", Safari.addBookmark, { "Bookmarks", "Add bookmark" } },
    { nil, "i", Safari.showWebInspector, { "Develop", "Toggle Web Inspector" } },
    { nil, "l", Safari.openLocation, { "File", "Open Location..." } },
    { nil, "m", Safari.toggleMute, { "Media", "Toggle Mute" } },
    { nil, "n", Safari.openNewWindow, { "File", "Open New Window" } },
    { nil, "o", Safari.openFile, { "File", "Open File" } },
    { nil, "r", function(...) Safari:reload(...) end, { "View", "Reload Page" } },
    { nil, "t", Safari.openNewTab, { "File", "Open New Tab" } },
    { nil, "u", Safari.undoCloseTab, { "File", "Undo Close Tab" } },
    { nil, "w", function(...) Safari:close(...) end, { "File", "Close Tab or Window" } },
    { nil, "y", Safari.showHistory, { "History", "Show History" } },
    { nil, "space", Safari.toggleMedia, { "Media", "Play/Pause Media" } },
    { { "ctrl" }, "c", Safari.toggleCaptions, { "Media", "Toggle Media Captions" } },
    { { "ctrl" }, "n", Safari.nextMedia, { "Media", "Next Media" } },
    { { "ctrl" }, "p", Safari.previousMedia, { "Media", "Previous Media" } },
    { { "ctrl" }, "s", Safari.skipMedia, { "Media", "Skip Media" } },
    { { "ctrl", "cmd" }, "m", Safari.moveTabToNewWindow, { "Window", "Move Tab To New Window" } },
    { { "cmd", "shift" }, "m", Safari.mergeAllWindows, { "Window", "Merge All Windows" } },
    { { "shift" }, "n", Safari.openNewPrivateWindow, { "File", "Open New Private Window" } },
})

return Safari
