----------------------------------------------------------------------------------------------------
-- Hammerspoon Lua script to retrieve the menu item shortcuts for an application
-- #!/usr/local/bin/hs
--
local shortcuts = {}
local UNMAPPED = "﴾unmapped﴿"
local applicationName = "{{entityName}}"
local includeUnmapped = {{includeUnmapped}}

-- Save currently frontmost window
local frontmostWindow = hs.window.frontmostWindow()

-- Activate application in order to enable as many shortcuts as possible
local app = hs.application.open(applicationName, 5)

-- Block execution for 1 second for the application to fully open properly
hs.timer.usleep(1000000)
if not app then return end

-- Refocus previously frontmost window
if frontmostWindow then frontmostWindow:focus() end

local menuBarTitleList = {}
local menuBarItems = app:getMenuItems()

-- Skip generic application menu item
for i = 2, #menuBarItems do
    local menuBarItem = menuBarItems[i]
    local menuBarTitle = menuBarItem.AXTitle
    local menuItems = menuBarItem.AXChildren[1]

    table.insert(menuBarTitleList, menuBarTitle)

    shortcuts[menuBarTitle] = {
        addedTitles = {}
    }

    for j = 1, #menuItems do
        local menuItem = menuItems[j]

        -- Menu items may be duplicated for hidden variants (using alt modifier key)
        local isDuplicate = shortcuts[menuBarTitle].addedTitles[menuItem.AXTitle]

        -- Check if menu item is a standard menu item with an assigned hotkey
        local isStandardMenuItem =
            menuItem.AXTitle ~= "" and
            menuItem.AXMenuItemCmdChar and
            not menuItem.AXChildren and
            not isDuplicate

        -- Check if menu item is a dropdown menu item with nested menu items
        local isMenuItemDropdown =
            menuItem.AXTitle ~= "" and
            menuItem.AXChildren and
            menuItem.AXChildren[1] and
            #menuItem.AXChildren[1] ~= 0

        local modifiers = {}

        if #menuItem.AXMenuItemCmdChar == 1 and
            #menuItem.AXMenuItemCmdModifiers > 0 and
            menuItem.AXMenuItemCmdModifiers or nil then

            for _, modifier in pairs(menuItem.AXMenuItemCmdModifiers) do
                -- Strip out "cmd" modifier to avoid conflicting with mode transitions
                if modifier ~= "cmd" then
                    table.insert(modifiers, modifier)
                end
            end

            if #modifiers == 0 then
                modifiers = nil
            end
        end

        local hotkey = #menuItem.AXMenuItemCmdChar == 1
            and { modifiers, menuItem.AXMenuItemCmdChar:lower() }
            or { { UNMAPPED }, UNMAPPED }

        if isStandardMenuItem then

            table.insert(shortcuts[menuBarTitle], {
                hotkey = hotkey,
                eventType = "createMenuItemEvent",
                metadata = { menuBarTitle, menuItem.AXTitle },
            })

        elseif isMenuItemDropdown then

            shortcuts[menuBarTitle].addedTitles[menuItem.AXTitle] = true

            table.insert(shortcuts[menuBarTitle], {
                hotkey = hotkey,
                eventType = "createMenuItemSelectionEvent",
                metadata = { menuBarTitle, menuItem.AXTitle },
            })
        end
    end

    shortcuts[menuBarTitle].addedTitles = nil

    table.sort(shortcuts[menuBarTitle], function(a, b)
        return hs.inspect(a) < hs.inspect(b)
    end)
end

print("return "..hs.inspect(shortcuts)..", "..hs.inspect(menuBarTitleList))
