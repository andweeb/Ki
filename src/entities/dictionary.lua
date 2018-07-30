local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Dictionary = Entity:subclass("Dictionary")

function Dictionary.newWindow(app)
    app:selectMenuItem("New Window")
    return true
end

function Dictionary.newTab(app)
    app:selectMenuItem("New Tab")
    return true
end

function Dictionary.search(app)
    app:selectMenuItem("Search For a New Word...")
    return true
end

function Dictionary:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "n", self.newWindow, { "File", "New Window" } },
        { nil, "t", self.newTab, { "File", "New Tab" } },
        { { "cmd" }, "f", self.search, { "Edit", "Search For a New Word..." } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Dictionary", shortcuts)
end

return Dictionary
