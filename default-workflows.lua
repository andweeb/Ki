--- === DefaultWorkflows ===
---
--- Definitions of default workflow events
---

local obj = {}
obj.__index = obj
obj.__name = "default-events"

local function getSpoonPath()
    return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
end

local function requirePackage(name)
    local luaVersion = _VERSION:match("%d+%.%d+")
    local packagePath = getSpoonPath().."/deps/share/lua/"..luaVersion.."/"..name..".lua"

    return dofile(packagePath)
end

local lustache = requirePackage("lustache")

local function renderAppleScriptTemplate(scriptName, viewModel)
    viewModel = viewModel or {}
    local scriptPath = getSpoonPath().."/scripts/"..scriptName..".applescript"
    local file = assert(io.open(scriptPath, "rb"))
    local scriptTemplate = file:read("*all")

    file:close()

    return lustache:render(scriptTemplate, viewModel)
end

local function getBrowserTabChoices(application)
    local choices = {}
    local script = renderAppleScriptTemplate("application-tab-titles", { application = application })
    local isOk, tabList, rawTable = hs.osascript.applescript(script)

    if not isOk then
        hs.notify.show("Ki", "Error fetching browser tab information", rawTable.NSLocalizedFailureReason)

        return {}
    end

    local windowIndex = 0

    for windowId, titleList in pairs(tabList) do
        windowIndex = windowIndex + 1
        for tabIndex, title in pairs(titleList) do
            table.insert(choices, {
                text = title,
                subText = "(Window "..windowIndex.." Tab #"..tabIndex..")",
                tabIndex = tabIndex,
                windowIndex = windowIndex,
                windowId = windowId,
            })
        end
    end

    return choices
end

function obj:activityMonitorEntityEventHandler()
    local appName = "Activity Monitor"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:calculatorEntityEventHandler()
    local appName = "Calculator"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:calendarEntityEventHandler()
    local appName = "Calendar"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app then app:activate() end

        if app and none and action.keyName == "n" then
            app:selectMenuItem("New Event")
        elseif app and none and (action.keyName == "f" or action.keyName == "l") then
            app:selectMenuItem("Find")
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none  and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:dictionaryEntityEventHandler()
    local appName = "Dictionary"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:faceTimePlayerEntityEventHandler()
    local appName = "FaceTime"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:finderEntityEventHandler()
    local appName = "Finder"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:handleChromeSelection(app)
    local choices = getBrowserTabChoices("Google Chrome")
    local action = self.ki.history.action

    self.ki:showSelectionModal(choices, function(choice)
        if not choice then return end

        local window = hs.window(tonumber(choice.windowId))

        if next(action) then
            local flags = action.flags
            local keyName = action.keyName
            local none = flags and flags:containExactly({})

            if app and none and keyName == "space" then
                local viewModel = {
                    browser = "Google Chrome",
                    command = "toggle-play",
                    target = "tab "..choice.tabIndex.." of window id "..choice.windowId,
                    ["is-chrome"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error toggling media", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "r" then
                local viewModel = { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
                local script = renderAppleScriptTemplate("reload-chrome", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error refreshing active window", rawTable.NSLocalizedFailureReason)
                end
            end
        else
            _ = window:focus() and window:focusTab(choice.tabIndex)
        end
    end)
end

function obj:googleChromeEntityEventHandler(hasSelection)
    local appName = "Google Chrome"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local function handleAction()
            local none = action.flags and action.flags:containExactly({})
            local shift = action.flags and action.flags:containExactly({ "shift" })

            if app and none and action.keyName == "o" then
                app:selectMenuItem("Open File...")
            elseif app and none and action.keyName == "n" then
                app:selectMenuItem("New Window")
            elseif app and shift and action.keyName == "n" then
                app:selectMenuItem("New Incognito Window")
            elseif app and none and action.keyName == "t" then
                app:selectMenuItem("New Tab")
            elseif app and none and action.keyName == "f" then
                app:activate()
                hs.window.focusedWindow():toggleFullScreen()
            elseif app and none and action.keyName == "i" then
                app:selectMenuItem("Developer Tools")
            elseif app and none and action.keyName == "space" then
                local viewModel = {
                    browser = "Google Chrome",
                    command = "toggle-play",
                    target = "front window's active tab",
                    ["is-chrome"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error toggling media", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "r" then
                local viewModel = { target = "the active tab of its first window" }
                local script = renderAppleScriptTemplate("reload-chrome", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error refreshing active window", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "," then
                app:selectMenuItem("Preferences...")
            elseif app and none and action.keyName == "h" then
                app:selectMenuItem("Hide "..appName)
            elseif app and none and action.keyName == "q" then
                app:selectMenuItem("Quit "..appName)
            end
        end

        -- Handle action normally through selection modal
        if (hasSelection) then
            self:handleChromeSelection(app)
        else
            handleAction()
            app:activate()
        end
    end)
end

function obj:iTunesEntityEventHandler()
    local appName = "iTunes"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "space" then
            _ = app:selectMenuItem("Play") or app:selectMenuItem("Pause")
        elseif app and none and action.keyName == "p" then
            app:selectMenuItem("Previous")
        elseif app and none and action.keyName == "n" then
            app:selectMenuItem("Next")
        elseif app and none and action.keyName == "s" then
            app:selectMenuItem("Stop")
        elseif app and none and action.keyName == "l" then
            app:selectMenuItem("Go to Current Song")
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:mailEntityEventHandler()
    local appName = "Mail"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:mapsEntityEventHandler()
    local appName = "Maps"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

local function getMessagesConversations()
    local choices = {}
    local isOk, conversations, rawTable =
        hs.osascript.applescript(renderAppleScriptTemplate("messages-conversations"))

    if not isOk then
        hs.notify.show("Ki", "Error fetching Messages app conversations", rawTable.NSLocalizedFailureReason)

        return {}
    end

    for index, conversation in pairs(conversations) do
        local contactName = string.gmatch(conversation, "([^.]+)")()

        table.insert(choices, {
            text = contactName,
            subText = string.sub(conversation, #contactName + 3),
            index = index,
        })
    end

    return choices
end

function obj:messagesEntityEventHandler(hasSelection)
    local appName = "Messages"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        local function handleAction()
            if app and not action.keyName then
                app:activate()
            elseif app and none and action.keyName == "n" then
                app:activate()
                app:selectMenuItem("New Message")
            elseif app and none and (action.keyName == "l" or action.keyName == "f") then
                app:activate()
                app:selectMenuItem("Find...")
            elseif app and none and action.keyName == "," then
                app:selectMenuItem("Preferences...")
            elseif app and none and action.keyName == "h" then
                app:selectMenuItem("Hide "..appName)
            elseif app and none and action.keyName == "q" then
                app:selectMenuItem("Quit "..appName)
            end
        end

        if (hasSelection) then
            local choices = getMessagesConversations()

            self.ki:showSelectionModal(choices, function(choice)
                if not choice then return end

                if app and not action.keyName then
                    app:activate()

                    local script = renderAppleScriptTemplate("select-messages-conversation", { index = choice.index })
                    local isOk, _, rawTable = hs.osascript.applescript(script)

                    if not isOk then
                        local message = "Error selecting the Messages app conversation"
                        hs.notify.show("Ki", message, rawTable.NSLocalizedFailureReason)
                    end
                end
            end)
        else
            hs.application.launchOrFocus(appName)
            handleAction()
        end

    end)
end

function obj:notesEntityEventHandler()
    local appName = "Notes"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})
        local shift = action.flags and action.flags:containExactly({ "shift" })

        if app then app:activate() end

        if app and none and action.keyName == "n" then
            app:selectMenuItem("New Note")
        elseif app and none and action.keyName == "f" then
            app:selectMenuItem("Show Folders")
        elseif app and shift and action.keyName == "n" then
            app:selectMenuItem("New Folder")
        elseif app and none and action.keyName == "l" then
            app:selectMenuItem("Search")
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:previewEntityEventHandler()
    local appName = "Preview"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app then app:activate() end

        if app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:handleSafariSelection(app)
    local choices = getBrowserTabChoices("Safari")
    local action = self.ki.history.action

    self.ki:showSelectionModal(choices, function(choice)
        if not choice then return end

        local window = hs.window(tonumber(choice.windowId))

        if next(action) then
            local flags = action.flags
            local keyName = action.keyName
            local none = flags and flags:containExactly({})

            if app and none and keyName == "space" then
                local viewModel = {
                    browser = "Safari",
                    command = "toggle-play",
                    target = "tab "..choice.tabIndex.." of window id "..choice.windowId,
                    ["is-safari"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error toggling media", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "r" then
                local viewModel = { target = "tab "..choice.tabIndex.." of front window" }
                local script = renderAppleScriptTemplate("reload-safari", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error refreshing active window", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "m" then
                local viewModel = {
                    browser = "Safari",
                    command = "toggle-mute",
                    target = "tab "..choice.tabIndex.." of window id "..choice.windowId,
                    ["is-safari"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error (un)muting video", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "w" then
                local viewModel = { target = "tab "..choice.tabIndex.." of window id "..choice.windowId }
                local script = renderAppleScriptTemplate("close-safari", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error closing window", rawTable.NSLocalizedFailureReason)
                end
            end
        else
            _ = window:focus() and window:focusTab(choice.tabIndex)
        end
    end)
end

function obj:safariEntityEventHandler(hasSelection)
    local appName = "Safari"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local function handleAction(lastEvent)
            lastEvent = lastEvent or {}
            local eventFlags = lastEvent.flags or action.flags
            local none = eventFlags and eventFlags:containExactly({})
            local shift = eventFlags and eventFlags:containExactly({ "shift" })
            local keyName = lastEvent.keyName or action.keyName

            if app and none and keyName == "o" then
                app:selectMenuItem("Open File...")
            elseif app and none and keyName == "n" then
                app:selectMenuItem("New Window")
            elseif app and shift and keyName == "n" then
                app:selectMenuItem("New Private Window")
            elseif app and none and keyName == "t" then
                app:selectMenuItem("New Tab")
            elseif app and none and keyName == "f" then
                app:activate()
                hs.window.focusedWindow():toggleFullScreen()
            elseif app and none and keyName == "l" then
                app:selectMenuItem("Open Location...")
            elseif app and none and keyName == "i" then
                app:selectMenuItem("Show Web Inspector")
            elseif app and none and keyName == "space" then
                local viewModel = {
                    browser = "Safari",
                    command = "toggle-play",
                    target = "front document",
                    ["is-safari"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error toggling media", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "r" then
                local script = renderAppleScriptTemplate("reload-safari", { target = "front document" })
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error refreshing active window", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and action.keyName == "m" then
                local viewModel = {
                    browser = "Safari",
                    command = "toggle-mute",
                    target = "front document",
                    ["is-safari"] = true,
                }
                local script = renderAppleScriptTemplate("browser-media", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error (un)muting video", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "w" then
                local viewModel = { pane = "current tab of front window" }
                local script = renderAppleScriptTemplate("close-safari", viewModel)
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error closing Safari tab", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "," then
                app:selectMenuItem("Preferences...")
            elseif app and none and keyName == "h" then
                app:selectMenuItem("Hide "..appName)
            elseif app and none and keyName == "q" then
                app:selectMenuItem("Quit "..appName)
            end
        end

        -- Handle action normally through selection modal
        if (hasSelection) then
            self:handleSafariSelection(app)
        else
            handleAction()
            app:activate()
        end
    end)
end

function obj:siriEntityEventHandler()
    local appName = "Siri"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            hs.application.open("Siri")
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:spotifyEntityEventHandler()
    local appName = "Spotify"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "space" then
            hs.spotify.playpause()
        elseif app and none and action.keyName == "p" then
            hs.spotify.previous()
        elseif app and none and action.keyName == "n" then
            hs.spotify.next()
        elseif app and none and action.keyName == "s" then
            hs.spotify.pause()
        elseif app and none and action.keyName == "l" then
            app:selectMenuItem("Search")
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:systemPreferencesEntityEventHandler()
    local appName = "System Preferences"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:terminalEntityEventHandler()
    local appName = "Terminal"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:quickTimePlayerEntityEventHandler()
    local appName = "QuickTime Player"

    return self.ki:createEntityEventHandler(appName, function(app, action)
        local none = action.flags and action.flags:containExactly({})

        if app and not action.keyName then
            app:activate()
        elseif app and none and action.keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and action.keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

--- DefaultWorkflows:init()
--- Method
--- Defines the default key bindings and initializes workflow event handlers for `entity`, `select`, and `url` mode
---
--- Parameters:
---  * `ki` - the ki object
---
--- Returns:
---  * A table containing the default `entity`, `select`, and `url` workflow events
function obj:init(ki)
    self.ki = ki

    local function initEntityEvents(hasSelection)
        return {
            { nil, "c", function() self:calendarEntityEventHandler() end },
            { nil, "c", function() self:calendarEntityEventHandler() end },
            { nil, "d", function() self:dictionaryEntityEventHandler() end },
            { nil, "f", function() self:finderEntityEventHandler() end },
            { nil, "g", function() self:googleChromeEntityEventHandler(hasSelection) end },
            { nil, "i", function() self:iTunesEntityEventHandler() end },
            { nil, "m", function() self:messagesEntityEventHandler(hasSelection) end },
            { nil, "n", function() self:notesEntityEventHandler() end },
            { nil, "s", function() self:safariEntityEventHandler(hasSelection) end },
            { nil, "t", function() self:terminalEntityEventHandler() end },
            { nil, "q", function() self:quickTimePlayerEntityEventHandler() end },
            { nil, ",", function() self:systemPreferencesEntityEventHandler() end },
            { { "cmd" }, "s", function() self:siriEntityEventHandler() end },
            { { "shift" }, "a", function() self:activityMonitorEntityEventHandler() end },
            { { "shift" }, "c", function() self:calculatorEntityEventHandler() end },
            { { "shift" }, "f", function() self:faceTimePlayerEntityEventHandler() end },
            { { "shift" }, "m", function() self:mapsEntityEventHandler() end },
            { { "shift" }, "s", function() self:spotifyEntityEventHandler() end },
            { { "shift", "cmd" }, "m", function() self:mailEntityEventHandler() end },
        }
    end

    local urlEvents = {
        { nil, "a", function() hs.urlevent.openURL("https://amazon.com") ki.state:exitMode() end },
        { nil, "f", function() hs.urlevent.openURL("https://facebook.com") ki.state:exitMode() end },
        { nil, "g", function() hs.urlevent.openURL("https://google.com") ki.state:exitMode() end },
        { nil, 'h', function() hs.urlevent.openURL('https://news.ycombinator.com') ki.state:exitMode() end },
        { nil, "l", function() hs.urlevent.openURL("https://linkedin.com") ki.state:exitMode() end },
        { nil, "m", function() hs.urlevent.openURL("https://messenger.com") ki.state:exitMode() end },
        { nil, "n", function() hs.urlevent.openURL("https://netflix.com") ki.state:exitMode() end },
        { nil, "r", function() hs.urlevent.openURL("https://reddit.com") ki.state:exitMode() end },
        { nil, "w", function() hs.urlevent.openURL("https://wikipedia.org") ki.state:exitMode() end },
        { nil, "y", function() hs.urlevent.openURL("https://youtube.com") ki.state:exitMode() end },
        { nil, "z", function() hs.urlevent.openURL("https://zillow.com") ki.state:exitMode() end },
        { { "shift" }, "g", function() hs.urlevent.openURL("https://github.com") ki.state:exitMode() end },
        { { "shift" }, "m", function() hs.urlevent.openURL("https://maps.google.com") ki.state:exitMode() end },
        { { "shift" }, "w", function() hs.urlevent.openURL("https://weather.com") ki.state:exitMode() end },
        { { "shift" }, "y", function() hs.urlevent.openURL("https://yelp.com") ki.state:exitMode() end },
        { { "cmd", "shift" }, 'm', function() hs.urlevent.openURL('https://mail.google.com') ki.state:exitMode() end },
    }

    return {
        url = urlEvents,
        select = initEntityEvents(true),
        entity = initEntityEvents(),
    }
end

return obj
