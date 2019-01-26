--- === File ===
---
--- File class that subclasses [Entity](Entity.html) to represent some directory or file
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
local Entity = _G.requirePackage("Entity", true)
local File = Entity:subclass("File")

--- File.behaviors
--- Variable
--- File [behaviors](Entity.html#behaviors) defined to invoke event handlers with the file path.
File.behaviors = Entity.behaviors + {
    default = function(self, eventHandler)
        eventHandler(self.path)
        return true
    end,
}

--- File:initialize(path, shortcuts)
--- Method
--- Initializes a new file instance with its path and custom shortcuts. By default, a cheatsheet and common shortcuts are initialized.
---
--- Parameters:
---  * `path` - The initial directory path
---  * `shortcuts` - The list of shortcuts containing keybindings and actions for the file entity
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
function File:initialize(path, shortcuts)
    local absolutePath = hs.fs.pathToAbsolute(path)
    local attributes = hs.fs.attributes(absolutePath) or {}
    local isDirectory = attributes.mode == "directory"

    local actions = {
        open = self.open,
        showCheatsheet = function() self.cheatsheet:show() end,
        openFileInFolder = self:createEvent(path, function(target) self.open(target) end),
        openFileInFolderWith = self:createEvent(path, function(target) self:openWith(target) end),
        showInfoForFileInFolder = self:createEvent(path, function(target) self:openInfoWindow(target) end),
        quickLookFileInFolder = self:createEvent(path, function(target) hs.execute("qlmanage -p "..target) end),
        deleteFileInFolder = self:createEvent(path, function(target) self:moveToTrash(target) end),
    }
    local commonShortcuts = {
        { nil, nil, actions.open, { path, "Activate/Focus" } },
        { { "shift" }, "/", actions.showCheatsheet, { path, "Show Cheatsheet" } },
    }

    -- Append directory shortcuts if the file entity is representing a directory path
    if isDirectory then
        local commonDirectoryShortcuts = {
            { nil, "d", actions.deleteFileInFolder, { path, "Move File in Folder to Trash" } },
            { nil, "o", actions.openFileInFolder, { path, "Open File in Folder" } },
            { nil, "i", actions.showInfoForFileInFolder, { path, "Get File Info for File in Folder" } },
            { nil, "space", actions.quickLookFileInFolder, { path, "Quick Look" } },
            { { "shift" }, "o", actions.openFileInFolderWith, { path, "Open File in Folder with App" } },
        }

        for _, shortcut in pairs(commonDirectoryShortcuts) do
            table.insert(commonShortcuts, shortcut)
        end
    end

    local mergedShortcuts = self.mergeShortcuts(shortcuts, commonShortcuts)

    self.path = path
    self.shortcuts = mergedShortcuts
    self.cheatsheet = cheatsheet

    local cheatsheetDescription = "Ki shortcut keybindings registered for file "..self.path
    self.cheatsheet:init(self.path, cheatsheetDescription, mergedShortcuts)
end

--- File:createEvent(path) -> function
--- Method
--- Convenience method to create file events that share the similar behavior of allowing navigation before item selection
---
--- Parameters:
---  * `path` - The path of a file
---
--- Returns:
---   * An event handler function
function File:createEvent(path, action)
    return function()
        self:navigate(path, action)
    end
end

--- File:getFileIcon(path) -> [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html)
--- Method
--- Retrieves an icon image for the given file path or returns nil if not found
---
--- Parameters:
---  * `path` - The path of a file
---
--- Returns:
---   * The file icon [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html) object
function File.getFileIcon(path)
    if not path then return end

    local bundleInfo = hs.application.infoForBundlePath(path)

    if bundleInfo and bundleInfo.CFBundleIdentifier then
        return hs.image.imageFromAppBundle(bundleInfo.CFBundleIdentifier)
    end

    local fileUTI = hs.fs.fileUTI(path)
    local fileImage = hs.image.iconForFileType(fileUTI)

    return fileImage
end

--- File:navigate(path, handler)
--- Method
--- Recursively navigates through parent and child directories until a selection is made
---
--- Parameters:
---  * `path` - the path of the target file
---  * `handler` - the selection callback handler function invoked with the following arguments:
---    * `targetFilePath` - the target path of the selected file
---
--- Returns:
---   * None
function File:navigate(path, handler)
    local absolutePath = hs.fs.pathToAbsolute(path)

    -- Defer execution to avoid conflicts with the selection modal that just previously closed
    hs.timer.doAfter(0, function()
        self:showFileSelectionModal(absolutePath, function(targetPath, shouldTriggerAction)
            local attributes = hs.fs.attributes(targetPath)

            if attributes.mode == "directory" and not shouldTriggerAction then
                self:navigate(targetPath, handler)
            else
                handler(targetPath)
            end
        end)
    end)
end

--- File:showFileSelectionModal(path, handler) -> [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) object list
--- Method
--- Shows a selection modal with a list of files at a given path.
---
--- Parameters:
---  * `path` - the path of the directory that should have its file contents listed in the selection modal
---  * `handler` - the selection event handler function that takes in the following arguments:
---     * `targetPath` - the selected target path
---     * `shouldTriggerAction` - a boolean value to ensure the action is triggered
---
--- Returns:
---   * A list of [choice](https://www.hammerspoon.org/docs/hs.chooser.html#choices) objects
function File:showFileSelectionModal(path, handler)
    local choices = {}
    local parentPathRegex = "^(.+)/.+$"
    local absolutePath = hs.fs.pathToAbsolute(path)
    local parentDirectory = absolutePath:match(parentPathRegex) or "/"
    local iterator, directory = hs.fs.dir(absolutePath)

    -- Add selection modal shortcut to open files with cmd + return
    local function openFile(modal)
        local selectedRow = modal:selectedRow()
        local choice = modal:selectedRowContents(selectedRow)
        handler(choice.filePath, true)
        modal:cancel()
    end
    local navigationShortcuts = {
        { { "cmd" }, "return", openFile },
    }
    self.selectionModalShortcuts = self.mergeShortcuts(navigationShortcuts, self.selectionModalShortcuts)

    if iterator == nil then
        self.notifyError("Error walking the path at "..path)
        return
    end

    for file in iterator, directory do
        local filePath = absolutePath.."/"..file
        local displayName = hs.fs.displayName(filePath) or file
        local subText = filePath

        if file == "." then
            displayName = file
            subText = absolutePath.." (Current directory)"
            filePath = absolutePath
        elseif file == ".." then
            displayName = file
            subText = parentDirectory.." (Parent directory)"
            filePath = parentDirectory
        end

        table.insert(choices, {
            text = displayName,
            subText = subText,
            file = file,
            filePath = filePath,
            image = filePath and self.getFileIcon(filePath),
        })
    end

    self.showSelectionModal(choices, function(choice)
        if choice then
            handler(choice.filePath)
        end
    end)
end

--- File:open(path)
--- Method
--- Opens a file or directory at the given path
---
--- Parameters:
---  * `path` - the path of the target file to open
---
--- Returns:
---   * None
function File.open(path)
    if not path then return nil end

    local absolutePath = hs.fs.pathToAbsolute(path)
    local attributes = hs.fs.attributes(absolutePath) or {}
    local isDirectory = attributes.mode == "directory"

    hs.open(absolutePath)

    if isDirectory then
        hs.application.open("Finder")
    end
end

--- File:openWith(path)
--- Method
--- Opens a file or directory at the given path with a specified application and raises the application to the front
---
--- Parameters:
---  * `path` - the path of the target file to open
---
--- Returns:
---   * None
function File:openWith(path)
    local allApplicationsPath = _G.spoonPath.."/bin/AllApplications"
    local shellscript = allApplicationsPath.." -path \""..path.."\""
    local output = hs.execute(shellscript)
    local choices = {}

    for applicationPath in string.gmatch(output, "[^\n]+") do
        local bundleInfo = hs.application.infoForBundlePath(applicationPath)
        local choice = {
            text = applicationPath,
            subText = applicationPath,
            applicationPath = applicationPath,
        }

        if bundleInfo then
            choice.text = bundleInfo.CFBundleName
            choice.image = hs.image.imageFromAppBundle(bundleInfo.CFBundleIdentifier)
        end

        table.insert(choices, choice)
    end

    -- Defer execution to avoid conflicts with the prior selection modal that just closed
    hs.timer.doAfter(0, function()
        self.showSelectionModal(choices, function(choice)
            if not choice then return end

            local isOk, _, rawTable = hs.osascript.applescript([[
                tell application "Finder"
                    open file ("]]..path..[[" as POSIX file) using ("]]..choice.applicationPath..[[" as POSIX file)
                end tell
            ]])

            if not isOk then
                self.notifyError("Error opening file with specified application", rawTable.NSLocalizedFailureReason)
            end
        end)
    end)
end

--- File:openInfoWindow(path)
--- Method
--- Opens a Finder information window for the file at `path`
---
--- Parameters:
---  * `path` - the path of the target file
---
--- Returns:
---   * None
function File:openInfoWindow(path)
    local isOk, _, rawTable = hs.osascript.applescript([[
        set targetFile to (POSIX file "]]..path..[[") as alias
        tell application "Finder"
            set infoWindow to information window of targetFile
            open infoWindow
            activate
        end tell
    ]])

    if not isOk then
        self.notifyError("Error getting info", rawTable.NSLocalizedFailureReason)
    end
end

--- File:moveToTrash(path)
--- Method
--- Moves a file or directory at the given path to the Trash. A dialog block alert opens to confirm before proceeding with the operation.
---
--- Parameters:
---  * `path` - the path of the target file to move to the trash
---
--- Returns:
---   * None
function File:moveToTrash(path)
    local question = "Move \""..path.."\" to the Trash?"

    self.triggerAfterConfirmation(question, function()
        local isOk, _, rawTable = hs.osascript.applescript([[
            tell application "Finder" to delete (POSIX file "]]..path..[[")
        ]])

        if not isOk then
            self.notifyError("Error moving file to trash", rawTable.NSLocalizedFailureReason)
        end
    end)
end

return File
