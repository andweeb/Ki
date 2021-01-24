----------------------------------------------------------------------------------------------------
-- Messages application config
--
local Ki = spoon.Ki
local Action = Ki.Action
local Application = Ki.Application
local ChooseMenuItem = Application.ChooseMenuItem
local SelectMenuItem = Application.SelectMenuItem
local unmapped = Application.unmapped

-- Action to activate the Messages app or a particular conversation
local Focus = Action {
    name = "Activate",
    action = function(app, choice)
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
}

return Application {
    name = "Messages",
    shortcuts = {
        Messages = {
            { nil, nil, Focus },
            { nil, ",", SelectMenuItem { "Messages", "Preferences…" } },
            { nil, "h", SelectMenuItem { "Messages", "Hide Messages" } },
            { nil, "q", SelectMenuItem { "Messages", "Quit Messages" } },
            { { "alt" }, "h", SelectMenuItem { "Messages", "Hide Others" } },
            { { "alt" }, "q", SelectMenuItem { "Messages", "Quit and Keep Windows" } },
            { unmapped, unmapped, SelectMenuItem { "Messages", "About Messages" } },
            { unmapped, unmapped, ChooseMenuItem { "Messages", "Services" } },
            { unmapped, unmapped, SelectMenuItem { "Messages", "Show All" } },
        },
        File = {
            { nil, "n", SelectMenuItem { "File", "New Message" } },
            { nil, "p", SelectMenuItem { "File", "Print…" } },
            { nil, "w", SelectMenuItem { "File", "Close Window" } },
            { { "alt" }, "w", SelectMenuItem { "File", "Close All Windows" } },
            { unmapped, unmapped, SelectMenuItem { "File", "<<Import From Device - unlocalized>>" } },
            { unmapped, unmapped, SelectMenuItem { "File", "Delete Conversation…" } },
            { unmapped, unmapped, SelectMenuItem { "File", "Open Conversation in Separate Window" } },
            { unmapped, unmapped, SelectMenuItem { "File", "Quick Look" } },
        },
        Edit = {
            { nil, "a", SelectMenuItem { "Edit", "Select All" } },
            { nil, "c", SelectMenuItem { "Edit", "Copy" } },
            { nil, "v", SelectMenuItem { "Edit", "Paste" } },
            { nil, "x", SelectMenuItem { "Edit", "Cut" } },
            { nil, "z", SelectMenuItem { "Edit", "Undo" } },
            { { "alt" }, "c", SelectMenuItem { "Edit", "Copy Style" } },
            { { "alt" }, "k", SelectMenuItem { "Edit", "Clear Transcript" } },
            { { "alt" }, "v", SelectMenuItem { "Edit", "Paste Style" } },
            { { "shift" }, "z", SelectMenuItem { "Edit", "Redo" } },
            { { "shift", "alt" }, "v", SelectMenuItem { "Edit", "Paste and Match Style" } },
            { unmapped, unmapped, SelectMenuItem { "Edit", "Complete" } },
            { unmapped, unmapped, SelectMenuItem { "Edit", "Delete" } },
            { unmapped, unmapped, SelectMenuItem { "Edit", "Emoji & Symbols" } },
            { unmapped, unmapped, ChooseMenuItem { "Edit", "Find" } },
            { unmapped, unmapped, SelectMenuItem { "Edit", "Send Message" } },
            { unmapped, unmapped, ChooseMenuItem { "Edit", "Speech" } },
            { unmapped, unmapped, ChooseMenuItem { "Edit", "Spelling and Grammar" } },
            { unmapped, unmapped, SelectMenuItem { "Edit", "Start Dictation" } },
            { unmapped, unmapped, ChooseMenuItem { "Edit", "Substitutions" } },
        },
        View = {
            { nil, "+", SelectMenuItem { "View", "Make Text Bigger" } },
            { nil, "-", SelectMenuItem { "View", "Make Text Smaller" } },
            { { "ctrl" }, "f", SelectMenuItem { "View", "Full Screen" } },
            { unmapped, unmapped, SelectMenuItem { "View", "Make Text Normal Size" } },
            { unmapped, unmapped, SelectMenuItem { "View", "Show All Buddy Pictures in Conversations" } },
            { unmapped, unmapped, ChooseMenuItem { "View", "Sort Conversations" } },
            { unmapped, unmapped, SelectMenuItem { "View", "Use Alerts in This Conversation" } },
        },
        Buddies = {
            { { "alt" }, "b", SelectMenuItem { "Buddies", "Show in Contacts" } },
            { { "alt" }, "e", SelectMenuItem { "Buddies", "Send Email…" } },
            { { "alt" }, "f", SelectMenuItem { "Buddies", "Send File…" } },
            { unmapped, unmapped, SelectMenuItem { "Buddies", "Ask to Share Screen" } },
            { unmapped, unmapped, SelectMenuItem { "Buddies", "Block Person…" } },
            { unmapped, unmapped, SelectMenuItem { "Buddies", "FaceTime Audio" } },
            { unmapped, unmapped, SelectMenuItem { "Buddies", "FaceTime Video" } },
            { unmapped, unmapped, SelectMenuItem { "Buddies", "Invite to Share My Screen" } },
        },
        Window = {
            { nil, "0", SelectMenuItem { "Window", "Messages" } },
            { nil, "m", SelectMenuItem { "Window", "Minimize" } },
            { { "alt" }, "m", SelectMenuItem { "Window", "Minimize All" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Arrange in Front" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Bring All to Front" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Move Window to Left Side of Screen" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Move Window to Right Side of Screen" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Select Next Conversation" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Select Previous Conversation" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Zoom All" } },
            { unmapped, unmapped, SelectMenuItem { "Window", "Zoom" } },
        },
        Help = {
            { unmapped, unmapped, SelectMenuItem { "Help", "Messages Help" } },
        },
    },

    -- Implement method to support selection of tab titles in select mode
    getChooserItems = function()
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
    end,
}
