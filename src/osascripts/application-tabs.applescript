-- AppleScript template for returning a record of application tab titles keyed by window id
-- `application` - name of any tabbable application (with AppleScript support)
tell application "{{application}}"
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
				set tabURL to URL of tabItem
				set escapedTabTitle to my replaceString(name of tabItem, "\"", "\\\"")
				set tabTitles to tabTitles & ("\"" & (escapedTabTitle) & " (" & tabURL & ")" & "\"" as string)
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

on replaceString(targetText, searchString, replacementString)
	set AppleScript's text item delimiters to the searchString
	set the itemList to every text item of targetText
	set AppleScript's text item delimiters to the replacementString
	set targetText to the itemList as string
	set AppleScript's text item delimiters to ""
	return targetText
end replaceString
