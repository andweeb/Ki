local Application = dofile(_G.spoonPath.."/application.lua")
local actions = {
    find = Application.createMenuItemEvent("Find...", { focusBefore = true }),
    newMessage = Application.createMenuItemEvent("New Message", { focusBefore = true }),
}

function Application.getSelectionItems()
    local choices = {}
    local isOk, conversations, rawTable =
        hs.osascript.applescript(Application.renderScriptTemplate("messages-conversations"))

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

function actions.focus(app, choice)
    app:activate()

    if choice then
        local script = Application.renderScriptTemplate("select-messages-conversation", { index = choice.index })
        local isOk, _, rawTable = hs.osascript.applescript(script)

        if not isOk then
            Application.notifyError("Error selecting the Message conversation", rawTable.NSLocalizedFailureReason)
        end
    end
end

local shortcuts = {
    { nil, nil, actions.focus, { "Messages", "Activate/Focus" } },
    { nil, "l", actions.find, { "Edit", "Search" } },
    { nil, "n", actions.newMessage, { "File", "New Message" } },
    { nil, "w", actions.close, { "File", "New Message" } },
    { { "cmd" }, "f", actions.find, { "Edit", "Search" } },
}

return Application:new("Messages", shortcuts)
