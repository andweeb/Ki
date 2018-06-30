-- AppleScript template for reloading a specific Chrome document, window, or tab
-- `target` - a string that describes the browser document, window, or tab target
tell application "Google Chrome" to tell {{target}}
    reload
end tell
