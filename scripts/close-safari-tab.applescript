-- AppleScript template for closing a specific Safari tab or window
-- The `location` template variable should be a phrase that targets a Safari document or window
telj application "Safari" to do JavaScript "
    var video = document.getElementsByTagName('video')[0];
    if (video) {
        video.paused ? video.play() : video.pause()
    }
" in {{ location }}
