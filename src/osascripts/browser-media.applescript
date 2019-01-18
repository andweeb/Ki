-- AppleScript template for playing or pausing an <audio> or <video> element in a browser
-- `browser` - the browser application name
-- `command` - the media command to apply to the browser target
-- `target` - a string that describes the browser document, window, or tab target
-- `is-chrome` - a boolean value for when the browser target is Google Chrome
-- `is-safari` - a boolean value for when the browser target is Safari
tell application "{{browser}}" to {{#is-safari}}do{{/is-safari}}{{#is-chrome}}execute {{&target}}{{/is-chrome}} JavaScript "
    var command = '{{command}}';

    function controlYouTubeMedia(command) {
        var media = document.getElementsByTagName('video')[0];

        if (media) {
            switch (command) {
                case 'toggle-play':
                    media.paused ? media.play() : media.pause();
                    break;
                case 'toggle-mute':
                    media.muted = !media.muted;
                    break;
                case 'toggle-captions':
                    var captionsButton = document.getElementsByClassName('ytp-subtitles-button')[0];
                    if (captionsButton) {
                        captionsButton.click();
                    }
                    break;
                case 'next':
                    var nextButton = document.getElementsByClassName('ytp-next-button')[0];
                    if (nextButton) {
                        nextButton.click();
                    }
                    break;
            }
        }
    }

    function controlNetflixMedia(command) {
        var media = document.getElementsByTagName('video')[0];

        if (media) {
            switch (command) {
                case 'toggle-play':
                    media.paused ? media.play() : media.pause();
                    break;
                case 'toggle-mute':
                    media.muted = !media.muted;
                    break;
                case 'skip':
                    var skipButton = document.querySelector('.skip-credits > a');
                    if (skipButton) {
                        skipButton.click();
                    }
                case 'next':
                    var nextButton = document.querySelector('[aria-label=\"Next Episode\"]');
                    if (nextButton) {
                        nextButton.click();
                    }
                    break;
            }
        }
    }

    function controlSoundCloudMedia(command) {
        switch (command) {
            case 'toggle-play':
                var playControl = document.getElementsByClassName('playControl')[0];
                if (playControl) {
                    playControl.click()
                }
                break;
            case 'next':
            case 'previous':
                var skipControl = command === 'previous'
                    ? document.getElementsByClassName('skipControl')[0]
                    : document.getElementsByClassName('skipControl')[1];
                if (skipControl) {
                    skipControl.click();
                }
                break;
            case 'toggle-mute':
                var volumeButton = document.getElementsByClassName('volume__button')[0];
                if (volumeButton) {
                    volumeButton.click()
                }
                break;
        }
    }

    function controlUnknownMedia(command) {
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
                    media.currentTime -= 10;
                    break;
                case 'seek-forward-10':
                    media.currentTime += 10;
                    break;
            }
        }
    }

    switch (window.location.host.replace('www.', '')) {
        case 'soundcloud.com':
            controlSoundCloudMedia(command);
            break;

        case 'youtube.com':
            controlYouTubeMedia(command);
            break;

        case 'netflix.com':
            controlNetflixMedia(command);
            break;

        default:
            controlUnknownMedia(command);
    }
"{{#is-safari}} in {{&target}}{{/is-safari}}
