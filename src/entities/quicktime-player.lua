local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    newAudioRecording = Application.createMenuItemEvent("New Audio Recording"),
    newMovieRecording = Application.createMenuItemEvent("New Movie Recording"),
    openFile = Application.createMenuItemEvent("Open File...", { focusAfter = true }),
    newScreenRecording = Application.createMenuItemEvent("New Screen Recording"),
}

function actions.openRecent(app)
    local menuItem = { "File", "Open Recent" }
    local menuItemList = Application.getMenuItemList(app, menuItem)
    local recentFileChoices = {}

    for _, item in pairs(menuItemList) do
        if item.AXTitle and #item.AXTitle > 0 then
            table.insert(recentFileChoices, {
                text = item.AXTitle,
            })
        end
    end

    Application.showSelectionModal(recentFileChoices, function(choice)
        if choice then
            table.insert(menuItem, choice.text)
            app:selectMenuItem(menuItem)
        end
    end)
end

local shortcuts = {
    { nil, "a", actions.newAudioRecording, { "File", "New Audio Recording" } },
    { nil, "m", actions.newMovieRecording, { "File", "New Movie Recording" } },
    { nil, "o", actions.openFile, { "File", "Open File..." } },
    { nil, "s", actions.newScreenRecording, { "File", "New Screen Recording" } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
}

return Application:new("QuickTime Player", shortcuts), shortcuts, actions
