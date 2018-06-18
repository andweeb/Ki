-- AppleScript template for returning a record of application tab titles keyed by window id
-- The `application` template variable should be any tabbable application with AppleScript support
tell application "{{ application }}"
	set windowTabTitles to {}
	set windowList to every window
	
	repeat with appWindow in windowList
		set ok to true
		set tabTitles to {}
		set appId to (id of appWindow as number)
		
		try
			set tabList to every tab of appWindow
		on error errorMessage
			set ok to false
		end try
		
		if ok then
			repeat with tabItem in tabList
				set tabTitles to tabTitles & ("\"" & (name of tabItem) & "\"" as string)
			end repeat
		end if
		
		set AppleScript's text item delimiters to ", "
		set delimitedTitles to tabTitles as string
		set AppleScript's text item delimiters to ""
		
		set titles to run script "{|" & appId & "|:{" & (delimitedTitles as string) & "}}"
		set windowTabTitles to windowTabTitles & titles
	end repeat
	
	return windowTabTitles
end tell
