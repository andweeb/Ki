--- === Cheatsheet ===
---
--- Cheatsheet modal used to display keyboard shortcuts
---

local Cheatsheet = {}
Cheatsheet.__index = Cheatsheet
Cheatsheet.__name = "Cheatsheet"

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

local lustache = _G.requirePackage("lustache")

local MODIFIER_GLYPHS = {
    cmd = "⌘",
    alt = "⌥",
    shift = "⇧",
    ctrl = "⌃",
    fn = "fn",
}
local KEY_GLYPHS = {
    ["return"] = "↩",
    enter = "⌤",
    delete = "⌫",
    escape = "⎋",
    right = "→",
    left = "←",
    up = "↑",
    down = "↓",
    pageup = "⇞",
    pagedown = "⇟",
    home = "↖",
    ["end"] = "↘",
    tab = "⇥",
    space = "␣",
}

-- Generate a view model of shortcuts partitioned into categories
function Cheatsheet._createShortcutBlocks(shortcutList)
    local shortcutBlocks = {}
    local shortcutCategories = {}

    for _, shortcut in pairs(shortcutList) do
        local shortcutModifierKeys = shortcut[_G.SHORTCUT_MODKEY_INDEX] or {}
        local shortcutKey = shortcut[_G.SHORTCUT_HOTKEY_INDEX] or ""
        local shortcutMetadata = shortcut[_G.SHORTCUT_METADATA_INDEX]

        if shortcutMetadata and #shortcutMetadata > 0 and shortcutMetadata[1] then
            local category = shortcutMetadata[1]
            local name = shortcutMetadata[2]
            local hotkey = ""

            if not shortcutCategories[category] then
                shortcutCategories[category] = {}
            end

            -- Create shortcut text
            for modifierKey, glyph in pairs(MODIFIER_GLYPHS) do
                for _, shortcutModifierKey in pairs(shortcutModifierKeys) do
                    if modifierKey == shortcutModifierKey then
                        hotkey = hotkey..glyph
                        break
                    end
                end
            end

            shortcutKey = KEY_GLYPHS[shortcutKey] or shortcutKey:gsub("^%l", string.upper)

            hotkey = hotkey..shortcutKey

            table.insert(shortcutCategories[category], {
                hotkey = hotkey,
                name = name,
            })
        end
    end

    for category, shortcuts in pairs(shortcutCategories) do
        local block = {{
            isTitle = true,
            name = category,
        }}

        -- Sort shortcuts by reversed hotkey
        table.sort(shortcuts, function(a, b)
            return string.reverse(a.hotkey) < string.reverse(b.hotkey)
        end)

        local used_shortcuts = {}
        for _, shortcut in pairs(shortcuts) do
            if used_shortcuts[shortcut.hotkey] == nil then
                used_shortcuts[shortcut.hotkey] = true
                table.insert(block, { name = shortcut.name, hotkey = shortcut.hotkey })
            end
        end

        table.insert(shortcutBlocks, { shortcuts = block })
    end

    -- Sort shortcut blocks by category name
    table.sort(shortcutBlocks, function(a, b)
        return a.shortcuts[1].name < b.shortcuts[1].name
    end)

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

    table.insert(shortcutBlocks, { shortcuts = glyphMapBlock })

    return shortcutBlocks
end

--- Cheatsheet:show()
--- Method
--- Show the cheatsheet modal. Hit Escape <kbd>⎋</kbd> to close.
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function Cheatsheet:show()
    local cssFilePath = _G.getSpoonPath().."/cheatsheet.css"
    local cssFile = assert(io.open(cssFilePath, "rb"))
    local css = cssFile:read("*all")
    cssFile:close()

    local htmlFilePath = _G.getSpoonPath().."/cheatsheet.html"
    local htmlFile = assert(io.open(htmlFilePath, "rb"))
    local html = htmlFile:read("*all")
    htmlFile:close()

    local appIconUri = nil
    local app = hs.application.get(self.name)

    if app then
        local bundleId = app:bundleID()
        local iconImage = hs.image.imageFromAppBundle(bundleId)
        appIconUri = iconImage:encodeAsURLString()
    end

    local title = self.name.." Cheat Sheet"
    local viewModel = {
        title = title,
        stylesheet = css,
        icon = appIconUri,
        description = self.description,
        shortcutBlocks = self._createShortcutBlocks(self.shortcuts),
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

    self.view:show()
    self.cheatsheetListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyName = hs.keycodes.map[event:getKeyCode()]

        if flags:containExactly({}) and keyName == "escape" then
            self.view:hide(0.5)
            self.cheatsheetListener:stop()
        end
    end)
    self.cheatsheetListener:start()
end

--- Cheatsheet:init(name, description, shortcuts[, view])
--- Method
--- Initialize the cheatsheet object
---
--- Parameters:
---  * `name` - The subject of the cheatsheet. An icon image will be rendered in the modal view for application names.
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
function Cheatsheet:init(name, description, shortcuts, view)
    self.name = name
    self.description = description
    self.shortcuts = shortcuts

    if not view then
        view = hs.webview.new({ x = 0, y = 0, w = 0, h = 0 })
        view:windowStyle({ "utility", "titled", "closable" })
        view:level(hs.drawing.windowLevels.modalPanel)
        view:darkMode(true)
        view:shadow(true)
    end

    self.view = view
end

return Cheatsheet
