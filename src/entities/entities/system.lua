----------------------------------------------------------------------------------------------------
-- System entity
--
local Ki = spoon.Ki
local Entity = Ki.Entity

local dialogMap = {
    ["log out"] = "Log out from your computer?",
    ["restart"] = "Restart your computer?",
    ["shut down"] = "Shut down your computer?",
    ["sleep"] = "Put your computer to sleep?",
}

-- Run some System Events actions in AppleScript
local function runSystemAppleScript(action)
    local isOk, _, rawTable = hs.osascript.applescript([[
        tell application "System Events"
            ]]..action..[[
        end tell
    ]])

    if not isOk then
        Entity.notifyError("Unable to "..action, rawTable.NSLocalizedFailureReason)
    end
end

-- AppleScript System Events action creator
local function systemEvent(action)
    return function()
        runSystemAppleScript(action)
    end
end

-- Create actions that involve user confirmation before running AppleScript
local function confirmSystemEvent(action)
    return function()
        Ki.state:exitMode()

        hs.timer.doAfter(0, function()
            hs.focus()

            local question = dialogMap[action]
            local confirmText = action:gsub('^%l', string.upper)
            local answer = hs.dialog.blockAlert(question, "", confirmText, "Cancel")
            if answer == confirmText then
                runSystemAppleScript(action)
            end
        end)
    end
end

return Entity {
    name = "System",
    shortcuts = {
        { { "ctrl" }, "l", confirmSystemEvent "log out",  { "Normal Mode",  "Log Out" } },
        { { "ctrl" }, "q", confirmSystemEvent "shut down",  { "Normal Mode",  "Shut Down" } },
        { { "ctrl" }, "r", confirmSystemEvent "restart",  { "Normal Mode",  "Restart" } },
        { { "ctrl" }, "s", systemEvent "sleep",  { "Normal Mode",  "Sleep" } },
        { { "cmd", "ctrl" }, "s", systemEvent "start current screen saver",  { "Normal Mode",  "Enter Screen Saver" } },
    },
}
