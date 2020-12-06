----------------------------------------------------------------------------------------------------
-- Safari application
--
local Action = spoon.Ki.Action
local Website = spoon.Ki.Website
local Application = spoon.Ki.Application

-- Initialize menu item events
local addBookmark = Application:createMenuItemAction("Add Bookmark...", { focusBefore = true })
local openLocation = Application:createMenuItemAction("Open Location...", { focusBefore = true })
local moveTabToNewWindow = Application:createMenuItemAction("Move Tab to New Window", { focusBefore = true })
local mergeAllWindows = Application:createMenuItemAction("Merge All Windows", { focusBefore = true })
local openNewWindow = Application:createMenuItemAction("New Window", { focusAfter = true })
local openNewPrivateWindow = Application:createMenuItemAction("New Private Window", { focusAfter = true })
local openFile = Application:createMenuItemAction("Open File...", { focusAfter = true })
local openNewTab = Application:createMenuItemAction("New Tab", { focusAfter = true })
local undoCloseTab = Application:createMenuItemAction("Reopen Last Closed Tab", { focusBefore = true })
local showHistory = Application:createMenuItemAction("Show All History", { focusAfter = true })
local showWebInspector = Application:createMenuItemAction({ "Show Web Inspector", "Close Web Inspector" }, {
    isToggleable = true,
    focusBefore = true,
})

-- Use a helper method to create various media actions
local function createMediaAction(name, command, errorMessage)
    return Action {
        name = name,
        action = function (_, choice)
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
    }
end
local toggleMute = createMediaAction("Toggle Mute", "toggle-mute", "Error (un)muting video")
local toggleMedia = createMediaAction("Play/Pause Media", "toggle-play", "Error toggling media")
local nextMedia = createMediaAction("Next Media", "Error going to the next media")
local previousMedia = createMediaAction("Previous Media", "Error going back to the previous media")
local toggleCaptions = createMediaAction("Toggle Media Captions", "Error toggling captions")
local skipMedia = createMediaAction("Skip Media", "Error skipping media")

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
        { nil, "d", addBookmark },
        { nil, "i", showWebInspector },
        { nil, "y", showHistory },
        File = {
            { nil, "l", openLocation },
            { nil, "n", openNewWindow },
            { nil, "o", openFile },
            { nil, "r", reload, "Reload Tab or Window" },
            { nil, "t", openNewTab },
            { nil, "u", undoCloseTab },
            { nil, "w", close, "Close Tab or Window" },
            { { "shift" }, "n", openNewPrivateWindow },
        },
        Media = {
            { nil, "m", toggleMute },
            { nil, "space", toggleMedia },
            { { "ctrl" }, "c", toggleCaptions },
            { { "ctrl" }, "n", nextMedia },
            { { "ctrl" }, "p", previousMedia },
            { { "ctrl" }, "s", skipMedia },
        },
        Window = {
            { { "ctrl", "cmd" }, "m", moveTabToNewWindow },
            { { "cmd", "shift" }, "m", mergeAllWindows },
        },
    },

    getChooserItems = getChooserItems,
}
