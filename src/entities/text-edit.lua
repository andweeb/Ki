local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    newDocument = Application.createMenuItemEvent("New", { focusAfter = true }),
    saveDocument = Application.createMenuItemEvent("Save", { focusAfter = true }),
    openDocument = Application.createMenuItemEvent("Open...", { focusAfter = true }),
    printDocument = Application.createMenuItemEvent("Print...", { focusBefore = true }),
    closeDocument = Application.createMenuItemEvent("Close", { focusBefore = true }),
    duplicateDocument = Application.createMenuItemEvent("Duplicate", { focusAfter = true }),
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
        if choice then
            table.insert(menuItem, choice.text)
            app:selectMenuItem(menuItem)
            Application.focus(app)
        end
    end

    Application.showSelectionModal(recentFileChoices, selectMenuItemAndFocus)
end

local shortcuts = {
    { nil, "n", actions.newDocument, { "File", "New Document" } },
    { nil, "o", actions.openDocument, { "File", "Open Document" } },
    { nil, "p", actions.printDocument, { "File", "Print Document" } },
    { nil, "s", actions.saveDocument, { "File", "Save Document" } },
    { nil, "w", actions.closeDocument, { "File", "Close Document" } },
    { { "shift" }, "o", actions.openRecent, { "File", "Open Recent" } },
    { { "shift" }, "s", actions.duplicateDocument, { "File", "Duplicate Document" } },
}

return Application:new("TextEdit", shortcuts), shortcuts, actions
