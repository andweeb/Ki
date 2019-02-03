-- AppleScript template for various file mode operations
-- `operation` - the operation name
-- `filePath1` - a string path to a file that will operated on
-- `filePath2` - a secondary string file path necessary for some operations
set operation to "{{{operation}}}"
set filePath1 to "{{{filePath1}}}"
set filePath2 to "{{{filePath2}}}"

tell application "Finder"

    if operation is "open-with" then

        open file (filePath1 as POSIX file) using (filePath2 as POSIX file)

    else if operation is "open-info-window" then

        set targetFile to (POSIX file filePath1) as alias
        set infoWindow to information window of targetFile

        open infoWindow

        activate

    else if operation is "move-to-trash" then

		delete (filePath1 as POSIX file)

    else if operation is "move" then

		move (filePath1 as POSIX file) to (filePath2 as POSIX file)

    else if operation is "copy" then

        duplicate POSIX file filePath1 as alias to POSIX file filePath2 as alias

    end if

end tell
