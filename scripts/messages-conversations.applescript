-- AppleScript to fetch a list of Messages conversations
-- The return value is a list of strings, each of the contact's name, last message, and time last sent
tell application "System Events"
	set conversations to {}

	tell table 1 of scroll area 1 of splitter group 1 of window 1 of application process "Messages"
		repeat with i from 1 to (count rows)
			set message to description of UI element 1 of row i
			set conversations to conversations & message
		end repeat
	end tell

	return conversations
end tell
