----------------------------------------------------------------------------------------------------
-- System Preferences application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local search = Application.createMenuItemEvent("Search", { focusBefore = true })
local showAllPreferences = Application.createMenuItemEvent("Show All Preferences", {
    focusBefore = true,
})

-- Implement method to support selection of system preferences in select mode
local function getChooserItems()
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

-- Action to activate System Preferences app or with a specific system preference pane
local function focus(app, choice)
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

return Application {
    name = "System Preferences",
    getChooserItems = getChooserItems,
    shortcuts = {
        { nil, nil, focus, "Activate" },
        { nil, "l", showAllPreferences, "Show All Preferences" },
        { { "shift" }, "f", search, "Search" },
    },
}
