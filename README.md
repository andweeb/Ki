# Ki

[![Build Status](https://travis-ci.com/andweeb/ki.svg?branch=master)](https://travis-ci.com/andweeb/ki) [![codecov](https://codecov.io/gh/andweeb/ki/branch/master/graph/badge.svg)](https://codecov.io/gh/andweeb/ki)

> A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.

### What's that?

Ki introduces a [modal paradigm](http://vimcasts.org/episodes/modal-editing-undo-redo-and-repeat) to automating macOS: as you would edit text objects with operators in [vi](https://en.wikipedia.org/wiki/Vi#Interface), you would automate entities with actions in Ki.

The default state of macOS could be considered to be in `desktop` mode. Ki binds the `Command` `Escape` <kbd>⌘⎋</kbd> hotkey to enter `normal` mode, in which an extensive set of keyboard shortcuts are available when using the [default config](src/default-config.lua).

To view all shortcuts, a cheatsheet can be activated with <kbd>⌘⎋</kbd><kbd>⌘e</kbd><kbd>?</kbd>.
* <kbd>⌘⎋</kbd> to enter `normal` mode
* <kbd>⌘e</kbd> to enter `entity` mode
* <kbd>?</kbd> to activate the `cheatsheet` entity

To see all shortcuts for actions that an entity implements, a cheatsheet can be activated with <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>?</kbd><kbd>(entity hotkey)</kbd>.
* <kbd>⌘⎋</kbd> to enter `normal` mode
* <kbd>⌘a</kbd> to enter `action` mode
* <kbd>?</kbd> to use the `open cheatsheet` action
* <kbd>(entity hotkey)</kbd> to apply the action to some target entity

<details>
 <summary>Click to view more example workflows and their modal keyboard shortcuts with accompanying descriptions.</summary>

<br>

We can use `entity`, `action`, and `select` mode to achieve various repetitive tasks starting from `desktop` mode:

Intent | Keybindings | Translation
:--- | :---: | :---
Launch or focus Safari | <kbd>⌘⎋</kbd><kbd>⌘e</kbd><kbd>s</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘e</kbd> enter `entity` mode <br>• <kbd>s</kbd>  target the **Safari** application
Toggle media in frontmost Safari window | <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>Space</kbd><kbd>s</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘a</kbd> enter `action` mode <br>• <kbd>Space</kbd> **toggle** media <br>• <kbd>s</kbd> target the **Safari** application
Focus the third Safari tab | <kbd>⌘⎋</kbd><kbd>⌘s</kbd><kbd>s</kbd><kbd>⌘3</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘s</kbd> enter `select` mode <br>• <kbd>s</kbd> target the **Safari** application <br>• <kbd>⌘3</kbd> target the **third** tab

With those semantics in mind, we can intuit other "sentences" if we know other entities <kbd>g</kbd>, <kbd>⇧s</kbd>, and <kbd>m</kbd>:

Intent | Keybindings | Translation
:--- | :---: | :---
Launch or focus Google Chrome | <kbd>⌘⎋</kbd><kbd>⌘e</kbd><kbd>g</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘e</kbd> enter `entity` mode <br>• <kbd>g</kbd>  target the **Google Chrome** application
Toggle current song in Spotify | <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>Space</kbd><kbd>⇧s</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘a</kbd> enter `action` mode <br>• <kbd>Space</kbd> **toggle** current song <br>• <kbd>⇧s</kbd> target the **Spotify** application
Focus the third Messages conversation | <kbd>⌘⎋</kbd><kbd>⌘s</kbd><kbd>m</kbd><kbd>⌘3</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘s</kbd> enter `select` mode <br>• <kbd>m</kbd> target the **Messages** application <br>• <kbd>⌘3</kbd> target the **third** conversation from the top

Combinations of the different modes can lead to even more complex workflows!

Intent | Keybindings | Translation
:--- | :---: | :---
Toggle media in the fourth Chrome tab | <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>Space</kbd><kbd>⌘s</kbd><kbd>g</kbd><kbd>⌘4</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘a</kbd> enter `action` mode <br>• <kbd>Space</kbd> **toggle** media <br>• <kbd>⌘s</kbd> enter `select` mode <br>• <kbd>g</kbd> target **Google Chrome** <br>• <kbd>⌘4</kbd> target the **fourth** tab
Close the second Safari tab | <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>w</kbd><kbd>⌘s</kbd><kbd>s</kbd><kbd>⌘2</kbd> | • <kbd>⌘⎋</kbd> enter `normal` mode <br> • <kbd>⌘a</kbd> enter `action` mode <br>• <kbd>w</kbd> **close** tab <br>• <kbd>⌘s</kbd> enter `select` mode <br>• <kbd>s</kbd> target the **Safari** application <br>• <kbd>⌘2</kbd> target the **second** tab

Ki has an ambitious goal of full automative coverage and already comes shipped with default hotkeys and actions for all native macOS applications. A number of other modes (`file`, `url`, etc.) are available for automating other aspects of macOS, and can be found in the Ki cheatsheet: <kbd>⌘⎋</kbd><kbd>⌘e</kbd><kbd>?</kbd>.
</details>

## Installation

Install [Hammerspoon](http://www.hammerspoon.org) and extract [Ki.spoon.zip](https://github.com/andweeb/ki/releases/latest) to `~/.hammerspoon/Spoons`.

## Usage and Configuration

### Usage

Load, configure, and start the plugin in `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon('Ki')                 -- load the plugin
spoon.Ki:useDefaultConfig()        -- use the default config (optional)
spoon.Ki:start()                   -- enable keyboard shortcuts
```

By default, Ki ships with predefined shortcuts for almost all native macOS applications, common directory files, and popular websites with preconfigured modes using a [default config](src/default-config.lua).

### Configuration

Nearly everything in Ki is configurable! Everyone uses their computer differently, so Ki provides an API to use the default config with particular options, register custom entities and their shortcuts, and even create custom modes and their modal shortcuts:

```lua
hs.loadSpoon('Ki')                             -- load the plugin
spoon.Ki:useDefaultConfig({                    -- use the default config with options as a base
    include = {                                -- include only the following default entities
        "google-chrome",
        "spotify",
        ...
    },
})
spoon.Ki:registerModes(transitions, shortcuts) -- register custom modes
spoon.Ki:registerShortcuts(shortcuts)          -- register custom shortcuts
spoon.Ki:start()                               -- enable keyboard shortcuts
```

API documentation can be found [here](https://andweeb.github.io/ki/html/Ki.html) and usage examples [here](docs/usage-examples).

## Development

```bash
# Setup
# Requires `luarocks` and `pip`
make deps      # install local luarocks dependencies necessary for Ki
make dev-deps  # install global luarocks dev dependencies and pip requirements for the docs generator

# Development
# The target names below can be prefixed with `watch-` to monitor for file changes using `fswatch`
make docs      # generate source documentation
make lint      # run linter on source and spec files
make test      # run busted unit tests and generate coverage files
make dev       # build and symlink the Ki spoon to the system spoons directory for quick development
make           # build and create a spoon zip file in the `dist` folder
```
