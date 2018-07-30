local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local spaces = require("hs._asm.undocumented.spaces")
local Spaces = Entity:subclass("Spaces")

function Spaces.getSelectionItems()
    local choices = {}
    local spaceIds = spaces.query()

    for i = #spaceIds, 1, -1 do
        local spaceId = spaceIds[i]
        local desktopIndex = #spaceIds - i + 1
        local spaceName = spaces.spaceName(spaceId)
        local windows = spaces.allWindowsForSpace(spaceId)
        local spaceApplications = ""

        if spaceName == "" then
            spaceName = "Primary Desktop"
        end

        if spaces.activeSpace() == spaceId then
            spaceName = spaceName.." (current space)"
        end

        for _, window in pairs(windows) do
            local appName = window:application():name()

            if spaceApplications == "" then
                spaceApplications = appName
            else
                spaceApplications = spaceApplications..", "..appName
            end
        end

        if spaceApplications == "" then
            spaceApplications = "No application windows"
        end

        table.insert(choices, {
            text = "Desktop #"..desktopIndex..": "..spaceApplications,
            subText = spaceName,
            spaceId = spaceId,
        })
    end

    return choices
end

function Spaces.create()
    local spaceId = spaces.createSpace()

    spaces.changeToSpace(spaceId)
end

function Spaces.focus(_, choice)
    if not choice then return end

    spaces.changeToSpace(choice.spaceId)
end

function Spaces.close(_, choice)
    if not choice then return end

    spaces.removeSpace(choice.spaceId)
end

function Spaces:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, nil, self.focus, { "Spaces", "Go to a Desktop Space" } },
        { nil, "n", self.create, { "Spaces", "Add a new Desktop Space" } },
        { nil, "w", self.close, { "Spaces", "Close a Desktop Space" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Desktop Spaces", shortcuts)
end

return Spaces
