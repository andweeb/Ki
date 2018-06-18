local obj = {}
obj.__index = obj
obj.__name = "triggers"

local HOME_DIRECTORY = os.getenv("HOME")
local SCRIPTS_DIRECTORY = HOME_DIRECTORY.."/.hammerspoon/Spoons/Ki.spoon/scripts"

local function parseAppleScriptTemplate(name, replacements)
    local scriptPath = SCRIPTS_DIRECTORY.."/"..name..".applescript"
    local file = assert(io.open(scriptPath, "rb"))
    local scriptTemplate = file:read("*all")
    local script = scriptTemplate

    for variable, replacement in pairs(replacements or {}) do
        script = string.gsub(script, "{{ "..variable.." }}", replacement)
    end

    file:close()

    return script
end

function obj:showChooser(choices, choiceHandler)
    local chooser = hs.chooser.new(choiceHandler)

    chooser:choices(choices)
    chooser:bgDark(true)

    chooser:show()
end

function obj:activityMonitorEntityEventHandler(choose)
    local appName = "Activity Monitor"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:calculatorEntityEventHandler(choose)
    local appName = "Calculator"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:calendarEntityEventHandler()
    local appName = "Calendar"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app then app:activate() end

        if app and none and keyName == "n" then
            app:selectMenuItem("New Event")
        elseif app and none and (keyName == "f" or keyName == "l") then
            app:selectMenuItem("Find")
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none  and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:dictionaryEntityEventHandler()
    local appName = "Dictionary"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:faceTimePlayerEntityEventHandler(choose)
    local appName = "FaceTime"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:finderEntityEventHandler(choose)
    local appName = "Finder"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:googleChromeEntityEventHandler()
    local appName = "Google Chrome"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})
        local shift = flags and flags:containExactly({ "shift" })

        if app and none and keyName == "o" then
            app:selectMenuItem("Open File...")
        elseif app and none and keyName == "n" then
            app:selectMenuItem("New Window")
        elseif app and shift and keyName == "n" then
            app:selectMenuItem("New Incognito Window")
        elseif app and none and keyName == "t" then
            app:selectMenuItem("New Tab")
        elseif app and none and keyName == "f" then
            app:selectMenuItem("Enter Full Screen")
        elseif app and none and keyName == "i" then
            app:selectMenuItem("Developer Tools")
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end

        if app then app:activate() end
    end)
end

function obj:iTunesEntityEventHandler()
    local appName = "iTunes"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "space" then
            _ = app:selectMenuItem("Play") or app:selectMenuItem("Pause")
        elseif app and none and keyName == "p" then
            app:selectMenuItem("Previous")
        elseif app and none and keyName == "n" then
            app:selectMenuItem("Next")
        elseif app and none and keyName == "s" then
            app:selectMenuItem("Stop")
        elseif app and none and keyName == "l" then
            app:selectMenuItem("Go to Current Song")
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:mailEntityEventHandler(choose)
    local appName = "Mail"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:mapsEntityEventHandler()
    local appName = "Maps"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

local function getMessagesConversations()
    local choices = {}
    local isOk, conversations, rawTable =
        hs.osascript.applescript(parseAppleScriptTemplate("messages-conversations"))

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

function obj:messagesEntityEventHandler(choose)
    local appName = "Messages"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local function handleAction()
            local none = flags and flags:containExactly({})

            if app and not keyName then
                app:activate()
            elseif app and none and keyName == "n" then
                app:activate()
                app:selectMenuItem("New Message")
            elseif app and none and (keyName == "l" or keyName == "f") then
                app:activate()
                app:selectMenuItem("Find...")
            elseif app and none and keyName == "," then
                app:selectMenuItem("Preferences...")
            elseif app and none and keyName == "h" then
                app:selectMenuItem("Hide "..appName)
            elseif app and none and keyName == "q" then
                app:selectMenuItem("Quit "..appName)
            end
        end

        if (choose) then
            local choices = getMessagesConversations()

            self:showChooser(choices, function(choice)
                if not choice then return end

                local script = parseAppleScriptTemplate("select-messages-conversation", { index = choice.index })
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error selecting the Messages app conversation", rawTable.NSLocalizedFailureReason)
                end

                handleAction()
            end)
        else
            hs.application.launchOrFocus(appName)
            handleAction()
        end

    end)
end

function obj:notesEntityEventHandler()
    local appName = "Notes"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})
        local shift = flags and flags:containExactly({ "shift" })

        if app then app:activate() end

        if app and none and keyName == "n" then
            app:selectMenuItem("New Note")
        elseif app and none and keyName == "f" then
            app:selectMenuItem("Show Folders")
        elseif app and shift and keyName == "n" then
            app:selectMenuItem("New Folder")
        elseif app and none and keyName == "l" then
            app:selectMenuItem("Search")
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:previewEntityEventHandler()
    local appName = "Preview"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app then app:activate() end

        if app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

local function getBrowserTabChoices(application)
    local choices = {}
    local script = parseAppleScriptTemplate("application-tab-titles", { application = application })
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

function obj:handleSafariChooser(app)
    local choices = getBrowserTabChoices("Safari")
    local breadcrumb = self.ki.trail.breadcrumb
    local action = {}

    -- Determine if there is an action to apply to a specific item in the chosen item
    for _, event in pairs(breadcrumb) do
        -- The next event will contain the action flags and keyName
        local key = next(breadcrumb, _)

        if event.eventName == "enterActionMode" and key ~= nil then
            action = breadcrumb[key]
        end
    end

    self:showChooser(choices, function(choice)
        if not choice then return end

        local window = hs.window(tonumber(choice.windowId))

        if next(action) then
            local flags = action.flags
            local keyName = action.keyName
            local none = flags and flags:containExactly({})

            if app and none and keyName == "space" then
                local location = "tab "..choice.tabIndex.." of window id "..choice.windowId
                local script = parseAppleScriptTemplate("toggle-safari-video", { location = location })
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Oops! Error toggling Safari video", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "w" then
                local script = [[tell application "Safari" to close tab ]]..choice.tabIndex..[[ of window id ]]..choice.windowId
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Oops! Error closing Safari tab", rawTable.NSLocalizedFailureReason)
                end
            end
        else
            _ = window:focus() and window:focusTab(choice.tabIndex)
        end
    end)
end

function obj:safariEntityEventHandler(choose)
    local appName = "Safari"

    return self.ki:createEntityEvent(appName, function(app, eventKeyName, flags)
        local function handleAction(lastEvent)
            lastEvent = lastEvent or {}
            local eventFlags = lastEvent.flags or flags
            local none = eventFlags and eventFlags:containExactly({})
            local shift = eventFlags and eventFlags:containExactly({ "shift" })
            local keyName = lastEvent.keyName or eventKeyName

            if app and none and keyName == "o" then
                app:selectMenuItem("Open File...")
            elseif app and none and keyName == "n" then
                app:selectMenuItem("New Window")
            elseif app and shift and keyName == "n" then
                app:selectMenuItem("New Private Window")
            elseif app and none and keyName == "t" then
                app:selectMenuItem("New Tab")
            elseif app and none and keyName == "f" then
                app:selectMenuItem("Enter Full Screen")
            elseif app and none and keyName == "l" then
                app:selectMenuItem("Open Location...")
            elseif app and none and keyName == "i" then
                app:selectMenuItem("Show Web Inspector")
            elseif app and none and keyName == "space" then
                local script = parseAppleScriptTemplate("toggle-safari-video", { location = "document 1" })
                local isOk, _, rawTable = hs.osascript.applescript(script)

                if not isOk then
                    hs.notify.show("Ki", "Error toggling Safari video", rawTable.NSLocalizedFailureReason)
                end
            elseif app and none and keyName == "," then
                app:selectMenuItem("Preferences...")
            elseif app and none and keyName == "h" then
                app:selectMenuItem("Hide "..appName)
            elseif app and none and keyName == "q" then
                app:selectMenuItem("Quit "..appName)
            end
        end

        -- Handle action normally through chooser modal
        if (choose) then
            self:handleSafariChooser(app)
        else
            handleAction()
            app:activate()
        end
    end)
end

function obj:spotifyEntityEventHandler(choose)
    local appName = "Spotify"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "space" then
            hs.spotify.playpause()
        elseif app and none and keyName == "p" then
            hs.spotify.previous()
        elseif app and none and keyName == "n" then
            hs.spotify.next()
        elseif app and none and keyName == "s" then
            hs.spotify.pause()
        elseif app and none and keyName == "l" then
            app:selectMenuItem("Search")
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:systemPreferencesEntityEventHandler(choose)
    local appName = "System Preferences"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:terminalEntityEventHandler(choose)
    local appName = "Terminal"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "," then
            app:selectMenuItem("Preferences...")
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:quickTimePlayerEntityEventHandler(choose)
    local appName = "QuickTime Player"

    return self.ki:createEntityEvent(appName, function(app, keyName, flags)
        local none = flags and flags:containExactly({})

        if app and not keyName then
            app:activate()
        elseif app and none and keyName == "h" then
            app:selectMenuItem("Hide "..appName)
        elseif app and none and keyName == "q" then
            app:selectMenuItem("Quit "..appName)
        end
    end)
end

function obj:init(ki)
    self.ki = ki

    local function initEntityEvents(choose)
        return {
            { nil, "c", function() self:calendarEntityEventHandler(choose) end },
            { nil, "d", function() self:dictionaryEntityEventHandler(choose) end },
            { nil, "f", function() self:finderEntityEventHandler(choose) end },
            { nil, "g", function() self:googleChromeEntityEventHandler(choose) end },
            { nil, "i", function() self:iTunesEntityEventHandler(choose) end },
            { nil, "m", function() self:messagesEntityEventHandler(choose) end },
            { nil, "n", function() self:notesEntityEventHandler(choose) end },
            { nil, "s", function() self:safariEntityEventHandler(choose) end },
            { nil, "t", function() self:terminalEntityEventHandler(choose) end },
            { nil, "q", function() self:quickTimePlayerEntityEventHandler(choose) end },
            { nil, ",", function() self:systemPreferencesEntityEventHandler(choose) end },
            { { "shift" }, "a", function() self:activityMonitorEntityEventHandler(choose) end },
            { { "shift" }, "c", function() self:calculatorEntityEventHandler(choose) end },
            { { "shift" }, "f", function() self:faceTimePlayerEntityEventHandler(choose) end },
            { { "shift" }, "m", function() self:mapsEntityEventHandler(choose) end },
            { { "shift" }, "s", function() self:spotifyEntityEventHandler(choose) end },
            { { "shift", "cmd" }, "m", function() self:mailEntityEventHandler(choose) end },
        }
    end

    local urlEvents = {
        { nil, "a", function() hs.urlevent.openURL("https://amazon.com") ki.state:exitMode() end },
        { nil, "f", function() hs.urlevent.openURL("https://facebook.com") ki.state:exitMode() end },
        { nil, "g", function() hs.urlevent.openURL("https://google.com") ki.state:exitMode() end },
        { nil, "l", function() hs.urlevent.openURL("https://linkedin.com") ki.state:exitMode() end },
        { nil, "m", function() hs.urlevent.openURL("https://messenger.com") ki.state:exitMode() end },
        { nil, "n", function() hs.urlevent.openURL("https://netflix.com") ki.state:exitMode() end },
        { nil, "r", function() hs.urlevent.openURL("https://reddit.com") ki.state:exitMode() end },
        { nil, "w", function() hs.urlevent.openURL("https://wikipedia.org") ki.state:exitMode() end },
        { nil, "y", function() hs.urlevent.openURL("https://youtube.com") ki.state:exitMode() end },
        { nil, "z", function() hs.urlevent.openURL("https://zillow.com") ki.state:exitMode() end },
        { { "shift" }, "m", function() hs.urlevent.openURL("https://maps.google.com") ki.state:exitMode() end },
        { { "shift" }, "w", function() hs.urlevent.openURL("https://weather.com") ki.state:exitMode() end },
        { { "shift" }, "y", function() hs.urlevent.openURL("https://yelp.com") ki.state:exitMode() end },
    }

    return {
        url = urlEvents,
        choose = initEntityEvents(true),
        entity = initEntityEvents(),
    }
end

return obj
