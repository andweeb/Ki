--- === SmartFolder ===
---
--- SmartFolder class that subclasses [File](File.html) to represent a [smart folder](https://support.apple.com/kb/PH25589) to be automated
---

local luaVersion = _VERSION:match("%d+%.%d+")

-- luacov: disable
if not _G.getSpoonPath then
    function _G.getSpoonPath()
        return debug.getinfo(2, "S").source:sub(2):match("(.*/)"):sub(1, -2)
    end
end
if not _G.requirePackage then
    function _G.requirePackage(name, isInternal)
        local location = not isInternal and "/deps/share/lua/"..luaVersion.."/" or "/"
        local packagePath = _G.getSpoonPath()..location..name..".lua"

        return dofile(packagePath)
    end
end
-- luacov: enable

local cheatsheet = _G.requirePackage("cheatsheet", true)
local File = _G.requirePackage("File", true)
local SmartFolder = File:subclass("File")

--- SmartFolder:initialize(path, shortcuts)
--- Method
--- Initializes a new smart folder entity instance with its search criteria file and custom shortcuts. By default, a cheatsheet and default shortcuts are initialized.
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---  * `shortcuts` - The list of shortcuts containing keybindings and actions for the smart folder entity
---
--- Each `shortcut` item should be a list with items at the following indices:
---  * `1` - An optional table containing zero or more of the following keyboard modifiers: `"cmd"`, `"alt"`, `"shift"`, `"ctrl"`, `"fn"`
---  * `2` - The name of a keyboard key. String representations of keys can be found in [`hs.keycodes.map`](https://www.hammerspoon.org/docs/hs.keycodes.html#map).
---  * `3` - The event handler that defines the action for when the shortcut is triggered
---  * `4` - A table containing the metadata for the shortcut, also a list with items at the following indices:
---    * `1` - The category name of the shortcut
---    * `2` - A description of what the shortcut does
---
--- Returns:
---  * None
function SmartFolder:initialize(path, shortcuts)
    path = hs.fs.pathToAbsolute(path)

    local actions = {
        copy = function(targetPath) self:copy(targetPath) end,
        moveToTrash = function(targetPath) self:moveToTrash(targetPath) end,
        openInfoWindow = function(targetPath) self:openInfoWindow(targetPath) end,
        move = function(targetPath) self:move(targetPath) end,
        openFile = function(targetPath) self:openFile(targetPath) end,
        openFileWith = function(targetPath) self:openFileWith(targetPath) end,
    }
    local commonShortcuts = {
        { nil, nil, self.open, { path, "Open Smart Folder" } },
        { nil, "c", actions.copy, { path, "Copy File in Smart Folder to a different location" } },
        { nil, "d", actions.moveToTrash, { path, "Move File in Smart Folder to Trash" } },
        { nil, "i", actions.openInfoWindow, { path, "Open Info Window for File in Smart Folder" } },
        { nil, "m", actions.move, { path, "Move File in Smart Folder to a different location" } },
        { nil, "o", actions.openFile, { path, "Open File in Smart Folder" } },
        { { "shift" }, "o", actions.openFileWith, { path, "Open Smart Folder File with Application" } },
        { { "shift" }, "/", actions.showCheatsheet, { path, "Show Cheatsheet" } },
    }

    local mergedShortcuts = self.mergeShortcuts(shortcuts, commonShortcuts)

    self.path = path
    self.shortcuts = mergedShortcuts
    self.cheatsheet = cheatsheet

    local cheatsheetDescription = "Ki shortcut keybindings registered for smart folder at "..self.path
    self.cheatsheet:init(self.path, cheatsheetDescription, mergedShortcuts)
end

--- SmartFolder:showFileSearchSelectionModal(path, callback)
--- Method
--- Shows a selection modal with smart folder search result choices
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---  * `callback` - The callback function invoked on a file choice selection with a choice object created from [`File.createFileChoices`](File.html#createFileChoices)
---
---
--- Returns:
---  * None
function SmartFolder:showFileSearchSelectionModal(path, callback)
    path = path or self.path

    local output = hs.execute([[
        mdfind "$(/usr/libexec/PlistBuddy -c 'Print RawQuery' ]]..path..[[)"
    ]])
    local choices = self.createFileChoices(string.gmatch(output, "[^\n]+"))

    self.showSelectionModal(choices, callback)
end

--- SmartFolder:openFile(path)
--- Method
--- Open a file from the smart folder search results
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:openFile(path)
    self:showFileSearchSelectionModal(path, function(choice)
        if choice then hs.open(choice.path) end
    end)
end

--- SmartFolder:copy(path)
--- Method
--- Copies a file in the smart folder search results to different folder
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:copy(path)
    local startingSearchPath = hs.fs.pathToAbsolute("~")

    self:showFileSearchSelectionModal(path, function(choice)
        if choice then
            local targetPath = choice.path

            self:navigate(startingSearchPath, function(destinationPath)
                local question = "Copy \""..targetPath.."\" to \""..destinationPath.."\"?"

                self.triggerAfterConfirmation(question, function()
                    self:runFileModeApplescript({
                        operation = "copy",
                        filePath1 = targetPath,
                        filePath2 = destinationPath,
                    })
                end)
            end)
        end
    end)
end

--- SmartFolder:moveToTrash(path)
--- Method
--- Moves a selected file in the smart folder search results to the Trash
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:moveToTrash(path)
    self:showFileSearchSelectionModal(path, function(choice)
        if choice then File:moveToTrash(choice.path) end
    end)
end

--- SmartFolder:move(path)
--- Method
--- Moves a selected file in the smart folder to a different folder
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:move(path)
    local startingSearchPath = hs.fs.pathToAbsolute("~")

    self:showFileSearchSelectionModal(path, function(choice)
        if choice then
            local targetPath = choice.path

            self:navigate(startingSearchPath, function(destinationPath)
                local question = "Move \""..targetPath.."\" to \""..destinationPath.."\"?"

                self.triggerAfterConfirmation(question, function()
                    self:runFileModeApplescript({
                        operation = "move",
                        filePath1 = targetPath,
                        filePath2 = destinationPath,
                    })
                end)
            end)
        end
    end)
end

--- SmartFolder:openFileWith(path)
--- Method
--- Open a file selected from the smart folder search results with a specific application
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:openFileWith(path)
    self:showFileSearchSelectionModal(path, function(choice)
        if choice then File:openWith(choice.path) end
    end)
end

--- SmartFolder:openInfoWindow(path)
--- Method
--- Opens a Finder information window for the file selected from the smart folder search results
---
--- Parameters:
---  * `path` - The path of the smart folder (`.savedSearch` file)
---
--- Returns:
---  * None
function SmartFolder:openInfoWindow(path)
    self:showFileSearchSelectionModal(path, function(choice)
        if choice then File:openInfoWindow(choice.path) end
    end)
end

return SmartFolder
