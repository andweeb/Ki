----------------------------------------------------------------------------------------------------
-- System Preferences application
--
local Application = spoon.Ki.Application
local SystemPreferences = Application:new("System Preferences")

SystemPreferences.search = Application.createMenuItemEvent("Search", { focusBefore = true })
SystemPreferences.showAllPreferences = Application.createMenuItemEvent("Show All Preferences", {
    focusBefore = true,
})

function SystemPreferences.getSelectionItems()
    local choices = {}
    local script = Application.renderScriptTemplate("system-preferences", { option = "fetch-panes" })
    local isOk, panes, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error fetching System Preferences panes", rawTable.NSLocalizedFailureReason)
    end

    for paneId, paneName in pairs(panes) do
        table.insert(choices, {
            paneId = paneId,
            text = paneName,
            subText = paneId,
        })
    end

    table.sort(choices, function(a, b)
        return a.text < b.text
    end)

    return choices
end

function SystemPreferences.focus(app, choice)
    app:activate()

    if choice then
        local script = Application.renderScriptTemplate("system-preferences", {
            option = "reveal-pane",
            targetPane = choice.paneId,
        })
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError("Error revealing System Preferences pane", rawTable.NSLocalizedFailureReason)
        end
    end
end

SystemPreferences:registerShortcuts({
    { nil, nil, SystemPreferences.focus, { "View", "Activate/Focus" } },
    { nil, "l", SystemPreferences.showAllPreferences, { "View", "Show All Preferences" } },
    { { "cmd" }, "f", SystemPreferences.search, { "View", "Search" } },
})

return SystemPreferences
