-- AppleScript template for activating a Chrome tab under a specific window
-- `target` - a string that describes the tab target
tell application "Google Chrome" to set active tab index of {{target}}
