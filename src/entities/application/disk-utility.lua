----------------------------------------------------------------------------------------------------
-- Disk Utility application
--
local Application = spoon.Ki.Application
local DiskUtility = Application:new("Disk Utility")

DiskUtility.newBlankImage = Application.createMenuItemEvent("Blank Image...", { focusAfter = true })
DiskUtility.newImageFromFolder = Application.createMenuItemEvent("Image From Folder...", {
    focusAfter = true,
})
DiskUtility.openDiskImage = Application.createMenuItemEvent("Open Disk Image...", {
    focusAfter = true,
})

DiskUtility:registerShortcuts({
    { nil, "n", DiskUtility.newBlankImage, { "File", "New Blank Image" } },
    { nil, "o", DiskUtility.openDiskImage, { "File", "Open Disk Image" } },
    { { "shift" }, "n", DiskUtility.newImageFromFolder, { "File", "New Image From Folder" } },
})

return DiskUtility
