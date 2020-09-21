local modifiers = {
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

local function createShortcutText(shortcutModifierKeys, shortcutKey)
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
    for modifierKey, glyph in pairs(modifiers) do
        for _, shortcutModifierKey in pairs(shortcutModifierKeys) do
            if modifierKey == shortcutModifierKey then
                hotkey = hotkey..glyph
                break
            end
        end
    end

    shortcutKey = keys[shortcutKey] or shortcutKey:gsub("^%l", string.upper)

    return hotkey..shortcutKey
end

return {
    keys = keys,
    modifiers = modifiers,
    createShortcutText = createShortcutText,
    unmapped = unmapped,
}
