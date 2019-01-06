local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    find = Application.createMenuItemEvent({ "Find", "Find..." }, { focusAfter = true }),
    open = Application.createMenuItemEvent("Open...", { focusAfter = true }),
    close = Application.createMenuItemEvent("Close Window", { focusBefore = true }),
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

    local function selectMenuItemAndFocus(choice)
        table.insert(menuItem, choice.text)
        app:selectMenuItem(menuItem)
        Application.focus(app)
    end

    Application.showSelectionModal(recentFileChoices, selectMenuItemAndFocus)
end

local shortcuts = {
    { nil, "o", actions.open, { "File", "Open..." } },
    { nil, "w", actions.close, { "File", "Close Window" } },
    { { "cmd" }, "f", actions.find, { "Edit", "Find..." } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
}

return Application:new("Preview", shortcuts), shortcuts, actions
