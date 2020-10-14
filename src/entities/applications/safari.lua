----------------------------------------------------------------------------------------------------
-- Safari application
--
local Website = spoon.Ki.Website
local Application = spoon.Ki.Application

-- Initialize menu item events
local addBookmark = Application.createMenuItemEvent("Add Bookmark...", { focusBefore = true })
local openLocation = Application.createMenuItemEvent("Open Location...", { focusBefore = true })
local moveTabToNewWindow = Application.createMenuItemEvent("Move Tab to New Window", { focusBefore = true })
local mergeAllWindows = Application.createMenuItemEvent("Merge All Windows", { focusBefore = true })
local openNewWindow = Application.createMenuItemEvent("New Window", { focusAfter = true })
local openNewPrivateWindow = Application.createMenuItemEvent("New Private Window", { focusAfter = true })
local openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true })
local openNewTab = Application.createMenuItemEvent("New Tab", { focusAfter = true })
local undoCloseTab = Application.createMenuItemEvent("Reopen Last Closed Tab", { focusBefore = true })
local showHistory = Application.createMenuItemEvent("Show All History", { focusAfter = true })
local showWebInspector = Application.createMenuItemEvent({ "Show Web Inspector", "Close Web Inspector" }, {
    isToggleable = true,
    focusBefore = true,
})

-- Use a helper method to create various media actions
local function createMediaAction(command, errorMessage)
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
local toggleMute = createMediaAction("toggle-mute", "Error (un)muting video")
local toggleMedia = createMediaAction("toggle-play", "Error toggling media")
local nextMedia = createMediaAction("next", "Error going to the next media")
local previousMedia = createMediaAction("previous", "Error going back to the previous media")
local toggleCaptions = createMediaAction("toggle-captions", "Error toggling captions")
local skipMedia = createMediaAction("skip", "Error skipping media")

-- Implement method to support selection of tab titles in select mode
local function getChooserItems()
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
                imageURL = Website:getFaviconURL(url),
            })
        end
    end

    return choices
end

-- Helper method to run AppleScript actions available in `osascripts/safari.applescript`
local function runApplescriptAction(errorMessage, viewModel)
    local script = Application.renderScriptTemplate("safari", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end
end

-- Action to reload a Safari tab or window
local function reload(_, choice)
    local viewModel = {
        action = "reload",
        target = "front document",
    }

    if choice then
        viewModel.target = "tab "..choice.tabIndex.." of window id "..choice.windowId
    end

    runApplescriptAction("Error reloading Safari tab", viewModel)
end

-- Action to close a Safari tab or window
local function close(_, choice)
    local viewModel = {
        action = "close",
        target = "current tab of front window",
    }

    if choice then
        viewModel.target = "tab "..choice.tabIndex.." of window id "..choice.windowId
    end

    runApplescriptAction("Error closing Safari tab", viewModel)
end

-- Action to focus a Safari tab for some window id
local function focusTab(windowId, tabIndex)
    runApplescriptAction("Error focusing Safari tab", {
        action = "focus-tab",
        windowId = windowId,
        tabIndex = tabIndex,
    })
end

-- Action to focus a Safari tab or window
--
-- Override `Application.focus` since there has been a `hs.window:focusTab` issue for
-- Safari after the v10.14.3 macOS update: https://github.com/Hammerspoon/hammerspoon/issues/2080
local function focus(app, choice)
    if choice then
        local windowId = choice.windowId
        local tabIndex = choice.tabIndex

        if tabIndex then
            focusTab(windowId, tabIndex)
        end

        local window = hs.window(tonumber(windowId))
        if windowId and window then
            window:focus()
        end
    elseif app then
        app:activate()
    end
end

return Application {
    name = "Safari",

    shortcuts = {
        { nil, nil, focus, "Activate" },
        { nil, "d", addBookmark, "Add bookmark" },
        { nil, "i", showWebInspector, "Toggle Web Inspector" },
        { nil, "y", showHistory, "Show History" },
        File = {
            { nil, "l", openLocation, "Open Location..." },
            { nil, "n", openNewWindow, "Open New Window" },
            { nil, "o", openFile, "Open File" },
            { nil, "r", reload, "Reload Page" },
            { nil, "t", openNewTab, "Open New Tab" },
            { nil, "u", undoCloseTab, "Undo Close Tab" },
            { nil, "w", close, "Close Tab or Window" },
            { { "shift" }, "n", openNewPrivateWindow, "Open New Private Window" },
        },
        Media = {
            { nil, "m", toggleMute, "Toggle Mute" },
            { nil, "space", toggleMedia, "Play/Pause Media" },
            { { "ctrl" }, "c", toggleCaptions, "Toggle Media Captions" },
            { { "ctrl" }, "n", nextMedia, "Next Media" },
            { { "ctrl" }, "p", previousMedia, "Previous Media" },
            { { "ctrl" }, "s", skipMedia, "Skip Media" },
        },
        Window = {
            { { "ctrl", "cmd" }, "m", moveTabToNewWindow, "Move Tab To New Window" },
            { { "cmd", "shift" }, "m", mergeAllWindows, "Merge All Windows" },
        },
    },

    getChooserItems = getChooserItems,
}
