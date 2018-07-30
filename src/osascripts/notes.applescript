-- AppleScript template for returning a list of note details
tell application "Notes"
	set userNotes to {}
	repeat with userNote in every note
		set noteContainer to container of userNote
		set end of userNotes to {noteId:id of userNote, noteName:name of userNote, lastModified:modification date of userNote as string, containerId:id of noteContainer, containerName:name of noteContainer}
	end repeat
	return userNotes
end tell
