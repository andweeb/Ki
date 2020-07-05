local MODIFIER_GLYPHS = {
    cmd = "⌘", alt = "⌥",
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
local unmapped = {
    key = "�",
    text = "﴾unmapped﴿",
}

return {
    keys = KEY_GLYPHS,
    modifiers = MODIFIER_GLYPHS,
    unmapped = unmapped,

    createShortcutText = function(shortcutModifierKeys, shortcutKey)
        local hotkey = ""

        if shortcutKey == nil and shortcutModifierKeys == nil then
            return "default"
        end
        if shortcutModifierKeys == unmapped.text or shortcutKey == unmapped.text then
            return unmapped.key
        end

        shortcutKey = shortcutKey or ""
        shortcutModifierKeys = shortcutModifierKeys or {}

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

        return hotkey..shortcutKey
    end,
}
