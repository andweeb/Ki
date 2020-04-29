-- AppleScript template for various file mode actions
-- `action` - the action name
set action to "{{{action}}}"

tell application "Safari"

    if action is "focus-tab" then

        {{#tabIndex}}
        -- `windowId` - target Safari window id
        -- `tabIndex` - target index of Safari tab to focus
        set windowId to {{{windowId}}}
        set tabIndex to {{{tabIndex}}}

        tell window id windowId
            set current tab to tab tabIndex
            set visible to true
            set index to 1
        end tell
        {{/tabIndex}}

    else if action is "close" then

        {{#target}}
        -- `target` - a string that describes the browser document, window, or tab target
        set target to {{target}}

        close target
        {{/target}}

    else if action is "reload" then

        {{#target}}
        -- `target` - a string that describes the browser document, window, or tab target
        set target to {{target}}

        set sameUrl to URL of target
        set URL of target to sameUrl
        {{/target}}

    end if

end tell
