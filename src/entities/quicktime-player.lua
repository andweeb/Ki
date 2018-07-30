local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local QuickTimePlayer = Entity:subclass("QuickTimePlayer")

function QuickTimePlayer.newAudioRecording(app)
    app:selectMenuItem("New Audio Recording")
end

function QuickTimePlayer.newMovieRecording(app)
    app:selectMenuItem("New Movie Recording")
end

function QuickTimePlayer.openFile(app)
    app:selectMenuItem("Open File...")
end

function QuickTimePlayer.openRecent(app)
    local menuItem = { "File", "Open Recent" }
    local menuItemList = QuickTimePlayer.getMenuItemList(app, menuItem)
    local recentFileChoices = {}

    for _, item in pairs(menuItemList) do
        if item.AXTitle then
            table.insert(recentFileChoices, {
                text = item.AXTitle,
            })
        end
    end

    QuickTimePlayer.showSelectionModal(app, recentFileChoices, function(_, choice)
        table.insert(menuItem, choice.text)
        app:selectMenuItem(menuItem)
    end)
end


function QuickTimePlayer.newScreenRecording(app)
    app:selectMenuItem("New Screen Recording")
end

function QuickTimePlayer:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, "a", self.newAudioRecording, { "File", "New Audio Recording" } },
        { nil, "m", self.newMovieRecording, { "File", "New Movie Recording" } },
        { nil, "o", self.openFile, { "File", "Open File..." } },
        { nil, "s", self.newScreenRecording, { "File", "New Screen Recording" } },
        { { "shift" }, "o", self.openRecent, { "File", "Open Recent" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "QuickTime Player", shortcuts)
end

return QuickTimePlayer
