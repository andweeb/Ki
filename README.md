# Ki

A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.

### The Idea

Native desktop shortcuts are pretty handy but are contextual and shallow in execution, eventually requiring manual effort to achieve complicated tasks.

Ki borrows principles from the [vi](https://en.wikipedia.org/wiki/Vi#Interface) text editor to <s>kill the mouse</s> streamline desktop workflows through modal, composable commands, constructed in the same way keystrokes in vi constitute "sentences":
- `⌘;s`: target and focus an entity `⌘;`, the Safari `s` application
- `⌘'<Space>s`: apply the action `⌘'` to toggle `<Space>` media playing in the frontmost Safari `s` window
- `⌘⇧'s⌘3`: select `⌘⇧'` a specific Safari `s` tab and focus the third one `⌘3` from the left

With those semantics in mind, we can intuit other "sentences" if we know other entities `⇧s` and `m`:
- `⌘;⇧s`: target and focus an entity `⌘;`, the Spotify `⇧s` application
- `⌘'<Space>⇧s`: apply the action `⌘'` to toggle `<Space>` the current song in the Spotify `⇧s` app
- `⌘⇧'m⌘3`: select `⌘⇧'` a specific Messages `m` conversation and focus the third one `⌘3` one from the top

With some applications, we can go even further!
- `⌘'d⌘⇧'g⌘2`: apply the action `⌘'` to add a bookmark `d` by selecting `⌘⇧'` the specific Google Chrome `g` tab, the second one `⌘2` from the left
- `⌘'w⌘⇧'m<Enter>`: apply the action `⌘'` to close an item `w` by selecting `⌘⇧'` the specific Messages `m` conversation, the first one `<Enter>` on top
- `⌘'<Space>⌘⇧'s4`: apply the action `⌘'` to toggle `<Space>` playing media by selecting `⌘⇧'` the specific Safari `s` tab, the fourth one `⌘4` from the left

## Installation

Install [Hammerspoon](https://github.com/Hammerspoon/hammerspoon) and extract [Ki.spoon]() to `~/.hammerspoon/Spoons` or run the following command in your terminal:
```bash
curl -Lo Ki.spoon.zip \
    https://github.com/andweeb/ki/blob/master/dist/Ki.spoon.zip\?raw\=true && \
    unzip Ki.spoon.zip -d ~/.hammerspoon/Spoons && \
    rm Ki.spoon.zip
```

## Usage and Configuration

Load, configure, and start the plugin in `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon('Ki')            -- initialize the plugin
spoon.Ki.workflows = {...}    -- add custom workflows and other various configurations
spoon.Ki:start()              -- enable keyboard shortcuts
```

#### Workflow events

Workflows are defined in lists under mode names. The workflow event structure follows Hammerspoon's `hs.hotkey.bind` arguments:

```lua
spoon.Ki.workflows = {
    entity = {                                                -- in entity mode:
        { nil, "s", safariEventHandler },                     -- "s" triggers the Safari event handler
        { {"cmd"}, "s", siriEventHandler },                   -- "⌘s" triggers the Siri event handler
        { {"shift"}, "s", spotifyEventHandler },              -- "⇧s" triggers the Spotify event handler
        { {"cmd", "shift"}, "s", slackEventHandler },         -- "⌘⇧s" triggers the Slack event handler
        { {"cmd", "alt", "shift"}, "s", skypeEventHandler },  -- "⌘⇧⌥s" triggers the Skype event handler
    },
    url = {                                                   -- in url mode:
        { nil, "g", googleUrlEventHandler },                  -- "g" opens google.com
        { {"shift"}, "g", githubUrlEventHandler },            -- "⇧g" opens github.com
        -- etc.
    },
}
```

Ki comes shipped with [default workflow events](), but custom definitions can be set to `Ki.workflows` to either override the default keybindings or set new ones. For example, the snippet above overwrites the default Safari, Siri, and Spotify events and adds new Slack and Skype events.  

### Transition events

Transition events are specific events in a workflow that either enter or exit a mode.
- `-- NORMAL --`: the initial desktop mode
    - enter entity mode with `⌘;`
    - enter action mode with `⌘'`
    - enter url mode with `⇧⌘;`
    - enter select mode with `⇧⌘'`
- `-- ENTITY --`: target a desktop entity
    - exit entity mode with `<Esc>`
    - enter select mode with `⇧⌘'`
- `-- ACTION --`: declare an action to be applied on a desktop entity
    - exit action mode with `<Esc>`
    - note: key events will transition directly to entity mode by default
- `-- URL --`: open a url in the default browser
    - exit url mode with `<Esc>`
- `-- SELECT --`: select a desktop entity from a list in a chooser modal
    - exit select mode with `<Esc>`

New modes can be added by setting [state events](https://github.com/unindented/lua-fsm#usage) to `Ki.states` and transition events to `Ki.transitions`, where the defined state transition functions can be invoked.

Documentation for all configurables can be found [here](https://github.com/andweeb/ki/blob/backup/docs/markdown/Ki.md).

## Development

```bash
# Setup
make deps         # install local luarocks dependencies for Ki
make test-deps    # install global luarocks dependencies for the test suite
make docs-deps    # install pip requirements for the docs generator

# Development
make lint         # run linter on source and spec files
make test         # run busted unit tests and generate coverage files
make              # build and symlink Ki to the system spoons directory for quick development
make spoon        # build and create a spoon zip file
```
