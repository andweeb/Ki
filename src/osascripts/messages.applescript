set action to "{{{action}}}"

if action is "get-conversations" then

    tell application "System Events"

        -- The return value is a list of strings, each of the contact's name, last message, and time last sent
        set conversations to {}

        tell table 1 of scroll area 1 of splitter group 1 of window 1 of application process "Messages"
            repeat with i from 1 to (count rows)
                set message to description of UI element 1 of row i
                set conversations to conversations & message
            end repeat
        end tell

        return conversations

    end tell

else if action is "select-conversation" then

    {{#index}}
    -- `index` - index of the target conversation to select
    tell application "System Events"
        tell table 1 of scroll area 1 of splitter group 1 of window 1 of application process "Messages"
            set selected of row {{index}} to true
        end tell
    end tell
    {{/index}}

end
