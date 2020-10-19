--- === Cheatsheet ===
---
--- Cheatsheet modal used to display registered keyboard shortcuts
---

local class = require("middleclass")
local lustache = require("lustache")
local glyphs = require("glyphs")

local spoonPath = hs.spoons.scriptPath()
local Cheatsheet = class("Cheatsheet")

-- Generate a view model of shortcuts partitioned into categories
function Cheatsheet:createShortcutBlocks()
    local shortcutBlocks = {}
    local nonModeShortcutBlocks = {}
    local modeShortcutBlocks = {}
    local shortcutCategories = {}

    local function initializeShortcutCategories(id, shortcut, category)
        local mods, key, handler, name = table.unpack(shortcut)

        if not name and type(handler) == "table" then
            name = handler.name
        end

        category = category or self.name
        name = name or tostring(handler)

        if not shortcutCategories[category] then
            shortcutCategories[category] = {}
        end

        table.insert(shortcutCategories[category], {
            hotkey = glyphs.createShortcutText(mods, key),
            name = name,
            id = id,
        })
    end

    local i = 1
    for key, value in pairs(self.shortcuts) do
        if type(key) == "string" and type(value) == "table" then
            local category = key
            local categorizedShortcuts = value
            for j, categorizedShortcut in pairs(categorizedShortcuts) do
                initializeShortcutCategories(i + j, categorizedShortcut, category)
            end
        else
            i = key
            local shortcut = value
            initializeShortcutCategories(key, shortcut)
        end
    end

    local index = 1
    for category, shortcuts in pairs(shortcutCategories) do
        if self.categoryFormatter then
            category = self.categoryFormatter(category)
        end

        local block = {{
            isTitle = true,
            id = #self.shortcuts + index,
            name = category,
        }}

        index = index + 1

        -- Sort shortcuts by reversed hotkey
        table.sort(shortcuts, function(a, b)
            return string.reverse(a.hotkey) < string.reverse(b.hotkey)
        end)

        local used_shortcuts = {}
        for _, shortcut in pairs(shortcuts) do
            local isUnmapped = shortcut.hotkey == glyphs.unmapped.key
            if isUnmapped then
                shortcut.hotkey = glyphs.unmapped.key
                shortcut.name = shortcut.name
                shortcut.isUnmapped = isUnmapped
            end

            if isUnmapped or used_shortcuts[shortcut.hotkey] == nil then
                used_shortcuts[shortcut.hotkey] = true
                table.insert(block, shortcut)
            end
        end

        if category == "Desktop Mode" or category == "Normal Mode" then
            table.insert(shortcutBlocks, block)
        elseif category:lower():find("mode") then
            table.insert(modeShortcutBlocks, block)
        else
            table.insert(nonModeShortcutBlocks, block)
        end
    end

    -- Sort shortcut blocks by their title names
    table.sort(shortcutBlocks, function(a, b) return a[1].name < b[1].name end)
    table.sort(modeShortcutBlocks, function(a, b) return a[1].name < b[1].name end)
    table.sort(nonModeShortcutBlocks, function(a, b) return a[1].name < b[1].name end)
    for _, block in pairs(modeShortcutBlocks) do table.insert(shortcutBlocks, block) end
    for _, block in pairs(nonModeShortcutBlocks) do table.insert(shortcutBlocks, block) end

    local glyphMapBlock = {{
        isTitle = true,
        name = "Cheat Sheet",
    }}

    table.insert(glyphMapBlock, { hotkey = "⌘", name = "Command" })
    table.insert(glyphMapBlock, { hotkey = "⌥", name = "Option/Alt" })
    table.insert(glyphMapBlock, { hotkey = "⌃", name = "Control" })
    table.insert(glyphMapBlock, { hotkey = "⇧", name = "Shift" })
    table.insert(glyphMapBlock, { hotkey = "fn", name = "Fn" })
    table.insert(glyphMapBlock, { hotkey = "↩", name = "Return" })
    table.insert(glyphMapBlock, { hotkey = "⌤", name = "Enter" })
    table.insert(glyphMapBlock, { hotkey = "⌫", name = "Delete" })
    table.insert(glyphMapBlock, { hotkey = "→", name = "Right Arrow" })
    table.insert(glyphMapBlock, { hotkey = "←", name = "Left Arrow" })
    table.insert(glyphMapBlock, { hotkey = "↑", name = "Up Arrow" })
    table.insert(glyphMapBlock, { hotkey = "↓", name = "Down Arrow" })
    table.insert(glyphMapBlock, { hotkey = "⇞", name = "Page Up" })
    table.insert(glyphMapBlock, { hotkey = "⇟", name = "Page Down" })
    table.insert(glyphMapBlock, { hotkey = "↖", name = "Home" })
    table.insert(glyphMapBlock, { hotkey = "↘", name = "End" })
    table.insert(glyphMapBlock, { hotkey = "⇥", name = "Tab" })
    table.insert(glyphMapBlock, { hotkey = "⎋", name = "Escape" })
    table.insert(glyphMapBlock, { hotkey = "␣", name = "Space" })
    table.insert(shortcutBlocks, glyphMapBlock)

    return shortcutBlocks
end

--- Cheatsheet:show([iconURL])
--- Method
--- Show the cheatsheet modal. Hit Escape <kbd>⎋</kbd> to close.
---
--- Parameters:
---  * `iconURL` - Image source of the cheatsheet icon
---
--- Returns:
---  * None
function Cheatsheet:show(iconURL)
    if not self.shortcuts then
        return nil
    end

    -- Store current frontmost window to restore after cheatsheet is dismissed
    local frontmostWindow = hs.window.frontmostWindow()

    local javascriptFilePath = spoonPath.."/cheatsheet/cheatsheet.js"
    local javascriptFile = assert(io.open(javascriptFilePath, "rb"))
    local javascript = javascriptFile:read("*all")
    javascriptFile:close()

    local cssFilePath = spoonPath.."/cheatsheet/cheatsheet.css"
    local cssFile = assert(io.open(cssFilePath, "rb"))
    local css = cssFile:read("*all")
    cssFile:close()

    local htmlFilePath = spoonPath.."/cheatsheet/cheatsheet.html"
    local htmlFile = assert(io.open(htmlFilePath, "rb"))
    local html = htmlFile:read("*all")
    htmlFile:close()

    local title = self.name.." Cheat Sheet"
    local shortcutBlocks = self:createShortcutBlocks()
    local viewModel = {
        title = title,
        icon = iconURL,
        description = self.description,
        data = hs.json.encode(shortcutBlocks),
        javascript = javascript,
        stylesheet = css,
    }

    self.view:windowTitle(title)

    local frame = hs.screen.mainScreen():fullFrame()
    self.view:frame({
        x = frame.x + frame.w * 0.15 / 2,
        y = frame.y + frame.h * 0.25 / 2,
        w = frame.w * 0.85,
        h = frame.h * 0.75,
    })

    local cheatsheetHtml = lustache:render(html, viewModel)
    self.view:html(cheatsheetHtml)

    -- Show webview and focus Hammerspoon
    self.view:show()
    hs.focus()

    self.cheatsheetListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local mods = event:getFlags()
        local key = hs.keycodes.map[event:getKeyCode()]

        if mods:containExactly({}) and key == "escape" then
            self.view:hide(0.5)
            self.cheatsheetListener:stop()
            frontmostWindow:focus()
        end
    end)

    self.cheatsheetListener:start()
end

--- Cheatsheet:initialize(name, description, shortcuts[, view])
--- Method
--- Initialize the cheatsheet object
---
--- Parameters:
---  * `name` - The subject of the cheatsheet.
---  * `description` - The description subtext to be rendered under the cheatsheet name
---  * `shortcuts` - A table containing the list of shortcuts to display in the cheatsheet
---  * `view` - An optional [`hs.webview`](https://www.hammerspoon.org/docs/hs.webview.html) instance to set custom styles for the cheatsheet. A titled, closable utility view will be configured with dark mode by default.
---
--- Each shortcut item in `shortcuts` must be a list with items at the following indices:
---  * `1` - An optional table containing zero or more of the following keyboard modifiers: `"cmd"`, `"alt"`, `"shift"`, `"ctrl"`, `"fn"`
---  * `2` - The name of a key. String representations of keys can be found in [`hs.keycodes.map`](https://www.hammerspoon.org/docs/hs.keycodes.html#map).
---  * `3` - The event handler function
---  * `4` - A table containing the metadata for the shortcut, also a list with items at the following indices:
---    * `1` - The category name of the shortcut
---    * `2` - A description of what the shortcut does
---
--- For example, the following Safari entity shortcuts will be rendered in the cheatsheet in the "File" category:
--- ```lua
--- { nil, "t", <function|Entity>, { "File", "Open New Tab" } },
--- { nil, "n", <function|Entity>, { "File", "Open New Window" } },
--- { { "shift" }, "n", <function|Entity>, { "File", "Open New Private Window" } },
--- ```
---
--- Returns:
---  * None
function Cheatsheet:initialize(options)
    self.name = options.name
    self.description = options.description
    self.shortcuts = options.shortcuts
    self.categoryFormatter = options.categoryFormatter

    local view = options.view
    if not options.view then
        view = hs.webview.new({ x = 0, y = 0, w = 0, h = 0 })
        view:windowStyle({ "utility", "titled", "closable" })
        view:level(hs.drawing.windowLevels.modalPanel)
        view:allowTextEntry(true)
        view:darkMode(true)
        view:shadow(true)
    end

    self.view = view
end

return Cheatsheet
