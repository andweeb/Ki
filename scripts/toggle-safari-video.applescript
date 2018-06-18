-- AppleScript template for playing or pausing a <video> element in a specific Safari tab
-- The `location` template variable should be a phrase that targets a Safari document or window
tell application "Safari" to do JavaScript "
    var video = document.getElementsByTagName('video')[0];
    if (video) {
        video.paused ? video.play() : video.pause()
    }
" in {{ location }}
