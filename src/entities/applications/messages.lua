----------------------------------------------------------------------------------------------------
-- Messages application
--
local Ki = spoon.Ki
local Application = Ki.Application

-- Initialize menu item events
local find = Application.createMenuItemEvent("Find...", { focusBefore = true })
local newMessage = Application.createMenuItemEvent("New Message", { focusBefore = true })

-- Implement method to support selection of tab titles in select mode
local function getChooserItems()
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
local function focus(app, choice)
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

return Application {
    name = "Messages",
    getChooserItems = getChooserItems,
    shortcuts = {
        { nil, nil, focus, "Activate" },
        { nil, "l", find, "Search" },
        { nil, "n", newMessage, "New Message" },
        { { "shift" }, "f", find, "Search" },
    },
}
