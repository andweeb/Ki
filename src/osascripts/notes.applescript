-- AppleScript template for returning a list of note details
-- `action` - the action name
set action to "{{{action}}}"

tell application "Notes"

    if action is "get-notes" then

        set userNotes to {}

        repeat with userNote in every note
            set noteContainer to container of userNote
            set end of userNotes to {noteId:id of userNote, noteName:name of userNote, lastModified:modification date of userNote as string}
        end repeat

        return userNotes

    else if action is "get-folders" then

        set userFolders to {}

        repeat with userFolder in every folder
            set end of userFolders to {folderId:id of userFolder, folderName:name of userFolder}
        end repeat

        return userFolders

    end if

end tell
