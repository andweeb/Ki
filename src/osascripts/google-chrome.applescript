-- AppleScript template for activating a Chrome tab under a specific window
set action to "{{{action}}}"

tell application "Google Chrome"

    if action is "focus-tab" then

        {{#tabIndex}}
        -- `target` - a string that describes the tab target
        set active tab index of window id {{windowId}} to {{tabIndex}}
        set index of window id {{windowId}} to 1
        {{/tabIndex}}

    else if action is "reload" then

        {{#target}}
        tell {{target}} to reload
        {{/target}}

    else if action is "close" then

        {{#target}}
        close {{target}}
        {{/target}}

    end if

end tell
