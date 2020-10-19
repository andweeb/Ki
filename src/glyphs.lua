local mods = {
    cmd   = "⌘",
    alt   = "⌥",
    shift = "⇧",
    ctrl  = "⌃",
    fn    = "fn",
}
local keys = {
    ["return"] = "↩",
    enter      = "⌤",
    delete     = "⌫",
    escape     = "⎋",
    right      = "→",
    left       = "←",
    up         = "↑",
    down       = "↓",
    pageup     = "⇞",
    pagedown   = "⇟",
    home       = "↖",
    ["end"]    = "↘",
    tab        = "⇥",
    space      = "␣",
}
local unmapped = {
    key  = "�",
    text = "﴾unmapped﴿",
}

local function createShortcutText(shortcutMods, shortcutKey)
    local hotkey = ""

    if shortcutKey == nil and shortcutMods == nil then
        return "default"
    end
    if shortcutMods == unmapped.text or shortcutKey == unmapped.text then
        return unmapped.key
    end

    shortcutKey = shortcutKey or ""
    shortcutMods = shortcutMods or {}

    -- Create shortcut text
    for mod, glyph in pairs(mods) do
        for _, shortcutMod in pairs(shortcutMods) do
            if mod == shortcutMod then
                hotkey = hotkey..glyph
                break
            end
        end
    end

    shortcutKey = keys[shortcutKey] or shortcutKey:gsub("^%l", string.upper)

    return hotkey..shortcutKey
end

return {
    mods = mods,
    keys = keys,
    createShortcutText = createShortcutText,
    unmapped = unmapped,
}
