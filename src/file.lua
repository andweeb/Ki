--- === File ===
---
--- File class that subclasses [Entity](Entity.html) to represent some directory or file to be automated
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
--- Currently supported behaviors:
--- * `default` - simply triggers the event handler with the instance's url string.
--- * `file` - triggers the appropriate event handler for the file entity instance. Depending on whether the workflow includes select mode, the event handler will be invoked with `shouldNavigate` set to `true`.
File.behaviors = Entity.behaviors + {
    default = function(self, eventHandler)
        eventHandler(self.path)
        return true
    end,
    file = function(self, eventHandler, _, _, workflow)
        local shouldNavigate = false

        for _, event in pairs(workflow) do
            if event.mode == "select" then
                shouldNavigate = true
                break
            end
        end

        eventHandler(self.path, shouldNavigate)

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
---  * `options` - A table containing various options that configures the file instance
---    * `showHiddenFiles` - A flag to display hidden files in the file selection modal. Defaults to `false`
---    * `sortAttribute` - The file attribute to sort the file selection list by. File attributes come from [hs.fs.dir](http://www.hammerspoon.org/docs/hs.fs.html#dir). Defaults to `modification` (last modified timestamp)
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
function File:initialize(path, shortcuts, options)
    options = options or {}

    local absolutePath = hs.fs.pathToAbsolute(path)

    if not absolutePath then
        self.notifyError("Error initializing File entity", "Path "..path.." may not exist.")
        return
    end

    local success, value = pcall(function() return hs.fs.attributes(absolutePath) or {} end)

    if not success then
        self.notifyError("Error initializing File entity", value or "")
        return
    end

    local attributes = value
    local isDirectory = attributes.mode == "directory"
    local openFileInFolder = self:createEvent(path, function(target) self.open(target) end)

    local actions = {
        copy = function(target) self:copy(target) end,
        move = function(target) self:move(target) end,
        showCheatsheet = function() self.cheatsheet:show() end,
        openFileInFolder = openFileInFolder,
        openFileInFolderWith = self:createEvent(path, function(target) self:openWith(target) end),
        showInfoForFileInFolder = self:createEvent(path, function(target) self:openInfoWindow(target) end),
        quickLookFileInFolder = self:createEvent(path, function(target) hs.execute("qlmanage -p "..target) end),
        deleteFileInFolder = self:createEvent(path, function(target) self:moveToTrash(target) end),
        open = function(target, shouldNavigate)
            if shouldNavigate then
                return openFileInFolder(target)
            end

            return self.open(target)
        end,
    }
    local commonShortcuts = {
        { nil, nil, actions.open, { path, "Activate/Focus" } },
        { { "shift" }, "/", actions.showCheatsheet, { path, "Show Cheatsheet" } },
    }

    -- Append directory shortcuts if the file entity is representing a directory path
    if isDirectory then
        local commonDirectoryShortcuts = {
            { nil, "c", actions.copy, { path, "Copy File to Folder" } },
            { nil, "d", actions.deleteFileInFolder, { path, "Move File in Folder to Trash" } },
            { nil, "i", actions.showInfoForFileInFolder, { path, "Open File Info Window" } },
            { nil, "m", actions.move, { path, "Move File to Folder" } },
            { nil, "o", actions.openFileInFolder, { path, "Open File in Folder" } },
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
    self.showHiddenFiles = options.showHiddenFiles or false
    self.sortAttribute = options.sortAttribute or "modification"

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

--- File:runFileModeApplescript(viewModel)
--- Method
--- Convenience method to render and run the `file-mode-operations.applescript` file and notify on execution errors. Refer to the applescript template file itself to see available view model records.
---
--- Parameters:
---  * `viewModel` - The view model object used to render the template
---
--- Returns:
---   * None
function File:runFileModeApplescript(viewModel)
    local script = self.renderScriptTemplate("file-mode-operations", viewModel)
    local isOk, _, rawTable = hs.osascript.applescript(script)

    if not isOk then
        local operationName = viewModel and "\""..viewModel.operation.."\"" or "unknown"
        local errorMessage = "Error executing the "..operationName.." file operation"
        self.notifyError(errorMessage, rawTable.NSLocalizedFailureReason)
    end
end

--- File:getFileIcon(path) -> [`hs.image`](http://www.hammerspoon.org/docs/hs.image.html)
--- Method
--- Retrieves an icon image for the given file path or returns `nil` if not found
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

    -- Add selection modal shortcut to open files with cmd + return
    local function openFile(modal)
        local selectedRow = modal:selectedRow()
        local choice = modal:selectedRowContents(selectedRow)
        handler(choice.filePath, true)
        modal:cancel()
    end
    -- Add selection modal shortcut to toggle hidden files cmd + shift + "."
    local function toggleHiddenFiles(modal)
        modal:cancel()
        self.showHiddenFiles = not self.showHiddenFiles

        -- Defer execution to avoid conflicts with the prior selection modal that just closed
        hs.timer.doAfter(0, function()
            self:showFileSelectionModal(path, handler)
        end)
    end
    local navigationShortcuts = {
        { { "cmd" }, "return", openFile },
        { { "cmd", "shift" }, ".", toggleHiddenFiles },
    }
    self.selectionModalShortcuts = self.mergeShortcuts(navigationShortcuts, self.selectionModalShortcuts)

    local iterator, directory = hs.fs.dir(absolutePath)
    if iterator == nil then
        self.notifyError("Error walking the path at "..path)
        return
    end

    for file in iterator, directory do
        local filePath = absolutePath.."/"..file
        local attributes = hs.fs.attributes(filePath) or {}
        local displayName = hs.fs.displayName(filePath) or file
        local isHiddenFile = string.sub(file, 1, 1) == "."
        local shouldShowFile = isHiddenFile and self.showHiddenFiles or not isHiddenFile
        local subText = filePath

        if file ~= "." and file ~= ".." and shouldShowFile then
            table.insert(choices, {
                text = displayName,
                subText = subText,
                file = file,
                filePath = filePath,
                image = filePath and self.getFileIcon(filePath),
                fileAttributes = attributes,
            })
        end
    end

    -- Sort choices by last modified timestamp and add current/parent directories to choices
    table.sort(choices, function(a, b)
        local value1 = a.fileAttributes[self.sortAttribute]
        local value2 = b.fileAttributes[self.sortAttribute]
        return value1 > value2
    end)
    table.insert(choices, {
        text = "..",
        subText = parentDirectory.." (Parent directory)",
        file = "..",
        filePath = parentDirectory,
        image = self.getFileIcon(absolutePath),
    })
    table.insert(choices, {
        text = ".",
        subText = absolutePath.." (Current directory)",
        file = ".",
        filePath = absolutePath,
        image = self.getFileIcon(absolutePath),
    })

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

--- File.createFileChoices(fileListIterator, createText, createSubText) -> choice object list
--- Method
--- Creates a list of choice objects each representing the file walked with the provided iterator
---
--- Parameters:
---  * `fileListIterator` - an iterator to walk a list of file paths, i.e. `s:gmatch(pattern)`
---  * `createText` - an optional function that takes in a single `path` argument to return a formatted string to assign to the `text` field in each file choice object
---  * `createSubText` - an optional function that takes in a single `path` argument to return a formatted string to assign to the `subText` field in each file choice object
---
--- Returns:
---   * `choices` - A list of choice objects each containing the following fields:
---     * `text` - The primary chooser text string
---     * `subText` - The chooser subtext string
---     * `fileName` - The name of the file
---     * `path` - The path of the file
function File.createFileChoices(fileListIterator, createText, createSubText)
    local choices = {}
    local fileNameRegex = "^.+/(.+)$"

    for path in fileListIterator do
        local bundleInfo = hs.application.infoForBundlePath(path)
        local fileName = path:match(fileNameRegex) or ""
        local choice = {
            text = createText and createText(path) or fileName,
            subText = createSubText and createSubText(path) or path,
            fileName = fileName,
            path = path,
        }

        if bundleInfo then
            choice.text = bundleInfo.CFBundleName
            choice.image = hs.image.imageFromAppBundle(bundleInfo.CFBundleIdentifier)
        end

        table.insert(choices, choice)
    end

    return choices
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
    local choices = self.createFileChoices(string.gmatch(output, "[^\n]+"))

    -- Defer execution to avoid conflicts with the prior selection modal that just closed
    hs.timer.doAfter(0, function()
        self.showSelectionModal(choices, function(choice)
            if not choice then return end

            self:runFileModeApplescript({
                operation = "open-with",
                filePath1 = path,
                filePath2 = choice.path,
            })
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
    self:runFileModeApplescript({ operation = "open-info-window", filePath1 = path })
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
        self:runFileModeApplescript({ operation = "move-to-trash", filePath1 = path })
    end)
end

--- File:move(path)
--- Method
--- Method to move one file into a directory. Opens a navigation modal for selecting the target file, then on selection opens another navigation modal to select the destination path. A confirmation dialog is presented to proceed with moving the file to the target directory.
---
--- Parameters:
---  * `path` - the initial directory path to select a target file to move
---
--- Returns:
---   * None
function File:move(initialPath)
    self:navigate(initialPath, function(targetPath)
        self:navigate(initialPath, function(destinationPath)
            local question = "Move \""..targetPath.."\" to \""..destinationPath.."\"?"

            self.triggerAfterConfirmation(question, function()
                self:runFileModeApplescript({
                    operation = "move",
                    filePath1 = targetPath,
                    filePath2 = destinationPath,
                })
            end)
        end)
    end)
end

--- File:copy(path)
--- Method
--- Method to copy one file into a directory. Opens a navigation modal for selecting the target file, then on selection opens another navigation modal to select the destination path. A confirmation dialog is presented to proceed with copying the file to the target directory.
---
--- Parameters:
---  * `path` - the initial directory path to select a target file to copy
---
--- Returns:
---   * None
function File:copy(initialPath)
    self:navigate(initialPath, function(targetPath)
        self:navigate(initialPath, function(destinationPath)
            local question = "Copy \""..targetPath.."\" to \""..destinationPath.."\"?"

            self.triggerAfterConfirmation(question, function()
                self:runFileModeApplescript({
                    operation = "copy",
                    filePath1 = targetPath,
                    filePath2 = destinationPath,
                })
            end)
        end)
    end)
end

return File
