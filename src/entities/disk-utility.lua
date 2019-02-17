local Application = dofile(_G.spoonPath.."/application.lua")

local actions = {
    newBlankImage = Application.createMenuItemEvent("Blank Image...", { focusAfter = true }),
    newImageFromFolder = Application.createMenuItemEvent("Image From Folder...", { focusAfter = true }),
    openDiskImage = Application.createMenuItemEvent("Open Disk Image...", { focusAfter = true }),
}

local shortcuts = {
    { nil, "n", actions.newBlankImage, { "File", "New Blank Image" } },
    { nil, "o", actions.openDiskImage, { "File", "Open Disk Image" } },
    { { "shift" }, "n", actions.newImageFromFolder, { "File", "New Image From Folder" } },
}

return Application:new("Disk Utility", shortcuts), shortcuts, actions
