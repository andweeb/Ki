-- AppleScript template for various file mode actions
-- `action` - the action name
-- `filePath1` - a string path to a file that will operated on
-- `filePath2` - a secondary string file path necessary for some actions
set action to "{{{action}}}"
set filePath1 to "{{{filePath1}}}"
set filePath2 to "{{{filePath2}}}"

tell application "Finder"

    if action is "open-with" then

        open file (filePath1 as POSIX file) using (filePath2 as POSIX file)

    else if action is "open-info-window" then

        set targetFile to (POSIX file filePath1) as alias
        set infoWindow to information window of targetFile

        open infoWindow

        activate

    else if action is "move-to-trash" then

		delete (filePath1 as POSIX file)

    else if action is "move" then

		move (filePath1 as POSIX file) to (filePath2 as POSIX file)

    else if action is "copy" then

        duplicate POSIX file filePath1 as alias to POSIX file filePath2 as alias

    end if

end tell
