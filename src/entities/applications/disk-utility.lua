----------------------------------------------------------------------------------------------------
-- Disk Utility application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local newBlankImage = Application.createMenuItemEvent("Blank Image...", { focusAfter = true })
local newImageFromFolder = Application.createMenuItemEvent("Image From Folder...", {
    focusAfter = true,
})
local openDiskImage = Application.createMenuItemEvent("Open Disk Image...", {
    focusAfter = true,
})

return Application {
    name = "Disk Utility",
    shortcuts = {
        { nil, "n", newBlankImage, { "File", "New Blank Image" } },
        { nil, "o", openDiskImage, { "File", "Open Disk Image" } },
        { { "shift" }, "n", newImageFromFolder, { "File", "New Image From Folder" } },
    },
}
