----------------------------------------------------------------------------------------------------
-- General macOS system entity
--
local Ki = spoon.Ki
local Entity = spoon.Ki.Entity
local System = Entity:new("System")

-- Helper method to run some AppleScript action
function System:runSystemApplescriptAction(action)
    local isOk, _, rawTable = hs.osascript.applescript([[ tell application "System Events" to ]]..action)

    if not isOk then
        self.notifyError("Unable to "..action, rawTable.NSLocalizedFailureReason)
    end
end

-- Helper method to create actions that involve user confirmation before running AppleScript
function System:createConfirmApplescriptEvent(action, question)
    return function()
        Ki.state:exitMode()

        hs.timer.doAfter(0, function()
            hs.focus()

            if question then
                local confirmText = action:gsub('^%l', string.upper)
                local answer = hs.dialog.blockAlert(question, "", confirmText, "Cancel")
                if answer == confirmText then
                    self:runSystemApplescriptAction(action)
                end
            else
                self:runSystemApplescriptAction(action)
            end
        end)
    end
end

-- Initialize AppleScript events
System.logout = System:createConfirmApplescriptEvent("log out", "Log out from your computer?")
System.startScreenSaver = System:createConfirmApplescriptEvent("start current screen saver")
System.sleep = System:createConfirmApplescriptEvent("sleep")
System.restart = System:createConfirmApplescriptEvent("restart", "Restart your computer?")
System.shutdown = System:createConfirmApplescriptEvent("shut down", "Shut down your computer?")

System:registerShortcuts({
    { { "ctrl" }, "l", System.logout, { "Normal Mode", "Log Out" } },
    { { "ctrl" }, "q", System.shutdown, { "Normal Mode", "Shut Down" } },
    { { "ctrl" }, "r", System.restart, { "Normal Mode", "Restart" } },
    { { "ctrl" }, "s", System.sleep, { "Normal Mode", "Sleep" } },
    { { "cmd", "ctrl" }, "s", System.startScreenSaver, { "Normal Mode", "Enter Screen Saver" } },
}, true)

return System
