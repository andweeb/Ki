# Ki

[![Build Status](https://travis-ci.com/andweeb/ki.svg?branch=master)](https://travis-ci.com/andweeb/ki) [![codecov](https://codecov.io/gh/andweeb/ki/branch/master/graph/badge.svg)](https://codecov.io/gh/andweeb/ki)

> A proof of concept to apply the ["Zen" of vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) to desktop automation.

### What's that?

Ki introduces a novel approach to automating macOS. Inspired by the [vi text editor](https://en.wikipedia.org/wiki/Vi#Interface), Ki enables modal hotkeys to execute desktop tasks to determine whether it can be effective in a desktop environment.

The default state of macOS could be considered to be in `desktop` mode. Ki binds a `Command` `Escape` <kbd>⌘⎋</kbd> hotkey that transitions to `normal` mode, in which an extensive set of command chains can be initiated.

To view all Ki shortcuts, a cheatsheet modal can be activated with <kbd>⌘⎋</kbd><kbd>⌘e</kbd><kbd>?</kbd>. To see all shortcuts for actions that an entity implements, an entity-specific cheatsheet modal can be activated with <kbd>⌘⎋</kbd><kbd>⌘a</kbd><kbd>?</kbd><kbd>(entity hotkey)</kbd>.

<details>
 <summary>Click to view example workflows and their modal keybindings with accompanying descriptions.</summary>

<br>

We can use `entity`, `action`, and `select` mode to achieve various common tasks from `desktop` mode:

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

Load, configure, and start the plugin in `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon('Ki')                 -- initialize the plugin
spoon.Ki.workflowEvents = {...}    -- configure `spoon.Ki` here
spoon.Ki:start()                   -- enable keyboard shortcuts
```

Nearly everything in Ki is customizable! API documentation can be found [here](https://andweeb.github.io/ki/html/Ki.html) and usage examples [here](docs/usage-examples).

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
