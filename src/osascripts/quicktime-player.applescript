-- AppleScript template for various QuickTime Player options
-- `option` - the name of the option
-- `targetDocument` - the target QuickTime Player document
set option to "{{option}}"

tell application "QuickTime Player"

    set target to {{target}}

	if option is "toggle-play" then

        if target is playing then

            pause target

        else

            play target

        end if

    else if option is "stop" then

        stop target

    else if option is "toggle-looping" then

        if the first document is looping then

            set looping of target to false

        else

            set looping of target to true

        end if

        return looping of target

	end if

end tell
