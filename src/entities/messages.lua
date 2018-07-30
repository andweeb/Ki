local spoonPath = debug.getinfo(3, "S").source:sub(2):match("(.*/)"):sub(1, -2)
local Entity = dofile(spoonPath.."/entity.lua")
local Messages = Entity:subclass("Messages")

function Messages.getSelectionItems()
    local choices = {}
    local isOk, conversations, rawTable =
    hs.osascript.applescript(Messages.renderScriptTemplate("messages-conversations"))

    if not isOk then
        Messages.notifyError("Error fetching Messages conversations", rawTable.NSLocalizedFailureReason)

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

function Messages.focus(app, choice)
    app:activate()

    if choice then
        local script = Messages.renderScriptTemplate("select-messages-conversation", { index = choice.index })
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Messages.notifyError("Error selecting the Message conversation", rawTable.NSLocalizedFailureReason)
        end
    end
end

function Messages.find(app)
    Messages.focus(app)
    app:selectMenuItem("Find...")
end

function Messages.selectNextConversation(app)
    Messages.focus(app)
    app:selectMenuItem("Select Next Conversation")
    return true
end

function Messages.selectPreviousConversation(app)
    Messages.focus(app)
    app:selectMenuItem("Select Previous Conversation")
    return true
end

function Messages:initialize(shortcuts)
    local defaultShortcuts = {
        { nil, nil, self.focus, { self.name, "Activate/Focus" } },
        { nil, "l", self.find, { "Edit", "Search" } },
        { nil, "n", self.newMessage, { "File", "New Message" } },
        { nil, "w", self.close, { "File", "New Message" } },
        { { "cmd" }, "f", self.find, { "Edit", "Search" } },
        { { "ctrl" }, "j", self.selectNextConversation, { "Window", "Select Next Conversation" } },
        { { "ctrl" }, "k", self.selectPreviousConversation, { "Window", "Select Previous Conversation" } },
    }

    shortcuts = Entity.mergeShortcuts(shortcuts, defaultShortcuts)

    Entity.initialize(self, "Messages", shortcuts)
end

return Messages
