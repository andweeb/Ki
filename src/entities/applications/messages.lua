----------------------------------------------------------------------------------------------------
-- Messages application
--
local Application = spoon.Ki.Application
local Messages = Application:new("Messages")

-- Initialize menu item events
Messages.find = Application.createMenuItemEvent("Find...", { focusBefore = true })
Messages.newMessage = Application.createMenuItemEvent("New Message", { focusBefore = true })

-- Implement method to support selection of tab titles in select mode
function Messages.getSelectionItems()
    local choices = {}
    local script = Application.renderScriptTemplate("messages", { action = "get-conversations" })
    local isOk, conversations, rawTable = hs.osascript.applescript(script)

    if not isOk then
        Application.notifyError("Error fetching Messages conversations", rawTable.NSLocalizedFailureReason)
        return {}
    end

    for index, conversation in pairs(conversations) do
        local contactName = string.gmatch(conversation, "([^.]+)")()

        table.insert(choices, {
            text = contactName,
            subText = string.sub(conversation, #contactName + 3),
            index = index,
        })
    end

    return choices
end

-- Action to activate the Messages app or a particular conversation
function Messages.focus(app, choice)
    app:activate()

    if choice then
        local script = Application.renderScriptTemplate("messages", {
            action = "select-conversation",
            index = choice.index,
        })
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError("Error selecting the Message conversation", rawTable.NSLocalizedFailureReason)
        end
    end
end

Messages:registerShortcuts({
    { nil, nil, Messages.focus, { "Messages", "Activate/Focus" } },
    { nil, "l", Messages.find, { "Edit", "Search" } },
    { nil, "n", Messages.newMessage, { "File", "New Message" } },
    { nil, "w", Messages.close, { "File", "New Message" } },
    { { "shift" }, "f", Messages.find, { "Edit", "Search" } },
})

return Messages
