----------------------------------------------------------------------------------------------------
-- Disk Utility application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newBlankImage = Application:createMenuItemAction("Blank Image...", { focusAfter = true })
local newImageFromFolder = Application:createMenuItemAction("Image From Folder...", {
    focusAfter = true,
})
local openDiskImage = Application:createMenuItemAction("Open Disk Image...", {
    focusAfter = true,
})

return Application {
    name = "Disk Utility",
    shortcuts = {
        { nil, "n", newBlankImage, "New Blank Image" },
        { nil, "o", openDiskImage, "Open Disk Image" },
        { { "shift" }, "n", newImageFromFolder, "New Image From Folder" },
    },
}
