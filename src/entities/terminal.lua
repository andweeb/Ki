local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Terminal = Entity:subclass("Terminal")

function Terminal.find(app)
    Terminal.focus(app)
    app:selectMenuItem("Find...")
end

function Terminal.newWindow(app)
    Terminal.focus(app)
    app:selectMenuItem("New Window with Profile .+$", true)
end

function Terminal.newTab(app)
    Terminal.focus(app)
    app:selectMenuItem("New Tab with Profile .+$", true)
end

function Terminal.close(app)
    Terminal.focus(app)
    _ = app:selectMenuItem("Close Tab") or app:selectMenuItem("Close Window")
end

function Terminal:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "n", self.newWindow, { "Shell", "New Window" } },
        { nil, "t", self.newTab, { "Shell", "New Tab" } },
        { nil, "w", self.close, { "Shell", "Close Tab or Window" } },
        { { "cmd" }, "f", self.find, { "Edit", "Find..." } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Terminal", shortcuts)
end

return Terminal
