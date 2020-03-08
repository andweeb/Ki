----------------------------------------------------------------------------------------------------
-- General macOS system entity
--
local Ki = spoon.Ki
local Entity = spoon.Ki.Entity
local System = Entity:new("System")

-- Fire an operation through applescript
function System:applescriptOperationEvent(operation, question)
    return function()
        Ki.state:exitMode()

        local function fireOperation()
            local script = self.renderScriptTemplate("system", { operation = operation })
            local isOk, _, rawTable = hs.osascript.applescript(script)

            if not isOk then
                self.notifyError("Unable to "..operation, rawTable.NSLocalizedFailureReason)
            end
        end

        hs.timer.doAfter(0, function()
            hs.focus()

            if question then
                local confirmText = operation:gsub('^%l', string.upper)
                local answer = hs.dialog.blockAlert(question, "", confirmText, "Cancel")
                if answer == confirmText then
                    fireOperation()
                end
            else
                fireOperation()
            end
        end)
    end
end

System.logout = System:applescriptOperationEvent("log out", "Log out from your computer?")
System.startScreenSaver = System:applescriptOperationEvent("start current screen saver")
System.sleep = System:applescriptOperationEvent("sleep")
System.restart = System:applescriptOperationEvent("restart", "Restart your computer?")
System.shutdown = System:applescriptOperationEvent("shut down", "Shut down your computer?")

System:registerShortcuts({
    { { "ctrl" }, "l", System.logout, { "Normal Mode", "Log Out" } },
    { { "ctrl" }, "q", System.shutdown, { "Normal Mode", "Shut Down" } },
    { { "ctrl" }, "r", System.restart, { "Normal Mode", "Restart" } },
    { { "ctrl" }, "s", System.sleep, { "Normal Mode", "Sleep" } },
    { { "cmd", "ctrl" }, "s", System.startScreenSaver, { "Normal Mode", "Enter Screen Saver" } },
}, true)

return System
