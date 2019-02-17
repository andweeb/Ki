-- AppleScript template for various system preferences options
-- `option` - the name of the option
-- `targetPane` - the target pane to reveal
set option to "{{option}}"
set targetPane to "{{targetPane}}"

tell application "System Preferences"

	if option is "fetch-panes" then

		set paneIdsByName to {}

		repeat with prefPane in panes
			set paneId to id of prefPane
			set paneName to name of prefPane as string

            set AppleScript's text item delimiters to {return & linefeed, return, linefeed, character id 8233, character id 8232}
            set paneName to text items of paneName
            set AppleScript's text item delimiters to {" "}
            set paneName to paneName as text

			set paneRecord to run script "{|" & paneId & "|:\"" & (paneName as string) & "\"}"
			set paneIdsByName to paneIdsByName & paneRecord
		end repeat

		return paneIdsByName

    else if option is "reveal-pane" then

        reveal pane targetPane

    else if option is "Accessibility" then

        reveal pane "com.apple.preference.universalaccess"

    else if option is "Bluetooth" then

        reveal pane "com.apple.preferences.bluetooth"

    else if option is "Date & Time" then

        reveal pane "com.apple.preference.datetime"

    else if option is "Desktop & Screen Saver" then

        reveal pane "com.apple.preference.desktopscreeneffect"

    else if option is "Displays" then

        reveal pane "com.apple.preference.displays"

    else if option is "Dock" then

        reveal pane "com.apple.preference.dock"

    else if option is "Energy Saver" then

        reveal pane "com.apple.preference.energysaver"

    else if option is "Extensions" then

        reveal pane "com.apple.preferences.extensions"

    else if option is "General" then

        reveal pane "com.apple.preference.general"

    else if option is "iCloud" then

        reveal pane "com.apple.preferences.icloud"

    else if option is "Internet Accounts" then

        reveal pane "com.apple.preferences.internetaccounts"

    else if option is "Keyboard" then

        reveal pane "com.apple.preference.keyboard"

    else if option is "Language & Region" then

        reveal pane "com.apple.localization"

    else if option is "Mission Control" then

        reveal pane "com.apple.preference.expose"

    else if option is "Mouse" then

        reveal pane "com.apple.preference.mouse"

    else if option is "Network" then

        reveal pane "com.apple.preference.network"

    else if option is "Notifications" then

        reveal pane "com.apple.preference.notifications"

    else if option is "Parental Controls" then

        reveal pane "com.apple.preferences.parentalcontrols"

    else if option is "Printers & Scanners" then

        reveal pane "com.apple.preference.printfax"

    else if option is "Security & Privacy" then

        reveal pane "com.apple.preference.security"

    else if option is "Sharing" then

        reveal pane "com.apple.preferences.sharing"

    else if option is "Siri" then

        reveal pane "com.apple.preference.speech"

    else if option is "Software Update" then

        reveal pane "com.apple.preferences.softwareupdate"

    else if option is "Sound" then

        reveal pane "com.apple.preference.sound"

    else if option is "Spotlight" then

        reveal pane "com.apple.preference.spotlight"

    else if option is "Startup Disk" then

        reveal pane "com.apple.preference.startupdisk"

    else if option is "Time Machine" then

        reveal pane "com.apple.prefs.backup"

    else if option is "Touch ID" then

        reveal pane "com.apple.preferences.password"

    else if option is "Trackpad" then

        reveal pane "com.apple.preference.trackpad"

    else if option is "Users & Groups" then

        reveal pane "com.apple.preferences.users"

    else if option is "Wallet & Apple Pay" then

        reveal pane "com.apple.preferences.wallet"

	end if

end tell
