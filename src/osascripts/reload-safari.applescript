-- AppleScript template for reloading a specific Safari document, window, or tab
-- `target` - a string that describes the browser document, window, or tab target
tell application "Safari"
    set sameUrl to URL of {{target}}
    set URL of {{target}} to sameUrl
end tell
