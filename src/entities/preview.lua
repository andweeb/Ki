local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Preview = Entity:subclass("Preview")

function Preview.find(app)
    app:selectMenuItem({ "Find", "Find..." })
    return true
end

function Preview.open(app)
    app:selectMenuItem("Open...")
    return true
end

function Preview.openRecent(app)
    local menuItem = { "File", "Open Recent" }
    local menuItemList = Preview.getMenuItemList(app, menuItem)
    local recentFileChoices = {}

    for _, item in pairs(menuItemList) do
        if item.AXTitle then
            table.insert(recentFileChoices, {
                text = item.AXTitle,
            })
        end
    end

    Preview.showSelectionModal(app, recentFileChoices, function(_, choice)
        table.insert(menuItem, choice.text)
        app:selectMenuItem(menuItem)
        Preview.focus(app)
    end)
end

function Preview:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "o", self.open, { "File", "Open..." } },
        { { "cmd" }, "f", self.find, { "Edit", "Find..." } },
        { { "shift" }, "o", self.openRecent, { "File", "Open Recent" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Preview", shortcuts)
end

return Preview
