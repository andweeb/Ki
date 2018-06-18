-- AppleScript template for selecting a Messages conversation at a specific index
-- The `index` template variable should be a number
tell application "System Events"
	tell table 1 of scroll area 1 of splitter group 1 of window 1 of application process "Messages"
		set selected of row {{ index }} to true
	end tell
end tell
