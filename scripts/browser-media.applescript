-- AppleScript template for playing or pausing an <audio> or <video> element in a browser
-- `browser` - the browser application name
-- `command` - the media command to apply to the browser target
-- `target` - a string that describes the browser document, window, or tab target
-- `is-chrome` - a boolean value for when the browser target is Google Chrome
-- `is-safari` - a boolean value for when the browser target is Safari
tell application "{{browser}}" to {{#is-safari}}do{{/is-safari}}{{#is-chrome}}execute {{&target}}{{/is-chrome}} JavaScript "
    var command = '{{command}}';
    var media = document.getElementsByTagName('video')[0] || document.getElementsByTagName('audio')[0];

    if (media) {
        switch (command) {
            case 'toggle-play':
                media.paused ? media.play() : media.pause();
                break;
            case 'toggle-mute':
                media.muted = !media.muted;
                break;
            case 'seek-backward-10':
                media.currentTime -= 10
                break;
            case 'seek-forward-10':
                media.currentTime += 10
                break;
        }
    }
"{{#is-safari}} in {{&target}}{{/is-safari}}
