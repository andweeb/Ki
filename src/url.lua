--- === URL ===
---
--- URL class that subclasses [Entity](Entity.html) to represent some automatable URL entity
---
local Entity = require("entity")
local Cheatsheet = require("cheatsheet")
local URL = Entity:subclass("URL")

--- URL.paths
--- Variable
--- An array of sub-paths of the URL or other related URLs. Defaults to an empty list, but it can be overridden to contain any of the following:
---  * The url sub-path that can be appended to the URL entity's path, i.e. /test
---  * The full url string, i.e. https://google.com
---  * A table containing a `name` and `path` field
URL.paths = {}

--- URL.displaySelectionModalIcons
--- Variable
--- A boolean value to specify whether to show favicons in the selection modal or not. Defaults to `true`.
URL.displaySelectionModalIcons = true

--- URL.behaviors
--- Variable
--- URL [behaviors](Entity.html#behaviors) defined to invoke event handlers with the URL.
--- Currently supported behaviors:
--- * `default` - Simply triggers the event handler with the entity's url
--- * `select` - Generates a list of choice items from [`self:getSelectionItems`](#getSelectionItems) and displays them in a selection modal for selection
--- * `url` - Triggers the appropriate event handler for the url. Depending on whether the workflow includes select mode, the select mode behavior will be triggered instead
URL.behaviors = Entity.behaviors + {
    default = function(self, eventHandler)
        eventHandler(self.url)
        return true
    end,
    select = function(self, eventHandler)
        local choices = self:getSelectionItems()

        if choices and #choices > 0 then
            local function onSelection(choice)
                if choice then
                    eventHandler(choice.url or self.url, choice)
                end
            end

            self:showSelectionModal(choices, onSelection)
        end

        return true
    end,
    url = function(self, eventHandler, _, _, workflow)
        local shouldSelect = false

        for _, event in pairs(workflow) do
            if event.mode == "select" then
                shouldSelect = true
                break
            end
        end

        if shouldSelect and URL.behaviors.select then
            return URL.behaviors.select(self, eventHandler)
        end

        return self.behaviors.default(self, eventHandler)
    end,
}

--- URL:getDomain(url) -> string
--- Method
--- Retrieves the domain part of the url argument
---
--- Parameters:
---  * `url` - The url string
---
--- Returns:
---   * The string domain of the url or `nil`
function URL.getDomain(url)
    return url:match("[%w%.]*%.(%w+%.%w+)") or url:match("[%w%.]*%/(%w+%.%w+)")
end

--- URL:getSelectionItems() -> table of choices or nil
--- Method
--- Generates a list of selection items using the instance's `self.paths` list. Each path item will display the page favicon if the [`URL.displaySelectionModalIcons`](URL.html#displaySelectionModalIcons) option is set to `true`.
---
--- Returns:
---   * A list of choice objects
function URL:getSelectionItems()
    local choices = {}

    for index, path in pairs(self.paths) do
        local pathStr = path.path or path

        if string.sub(pathStr, 1, 1) == "/" then
            pathStr = self.url..pathStr
        end

        local choice = {}

        if path.name and path.path then
            choice.text = path.name
            choice.subText = pathStr
            choice.url = pathStr
        else
            choice.text = pathStr
            choice.url = pathStr
        end

        if self.displaySelectionModalIcons then
            local domain = self.getDomain(pathStr)

            if domain then
                local favicon = "http://www.google.com/s2/favicons?domain_url="..domain

                -- Asynchronously load favicon images individually per selection item
                hs.image.imageFromURL(favicon, function(image)
                    if not self.selectionModal then
                        return
                    end

                    if choices[index] then
                        choices[index].image = image
                        self.selectionModal:choices(choices)
                    end
                end)
            end
        end

        table.insert(choices, choice)
    end

    return choices
end

--- URL:initialize(url, shortcuts)
--- Method
--- Initializes a new url entity instance with its url and custom shortcuts. By default, a cheatsheet and common shortcuts are initialized.
---
--- Parameters:
---  * `url` - The web address that the entity is representing
---  * `shortcuts` - The list of shortcuts containing keybindings and actions for the url entity
---
--- Each `shortcut` item should be a list with items at the following indices:
---  * `1` - An optional table containing zero or more of the following keyboard modifiers: `"cmd"`, `"alt"`, `"shift"`, `"ctrl"`, `"fn"`
---  * `2` - The name of a keyboard key. String representations of keys can be found in [`hs.keycodes.map`](https://www.hammerspoon.org/docs/hs.keycodes.html#map).
---  * `3` - The event handler that defines the action for when the shortcut is triggered
---  * `4` - A table containing the metadata for the shortcut, also a list with items at the following indices:
---    * `1` - The category name of the shortcut
---    * `2` - A description of what the shortcut does
---
--- Returns:
---  * None
function URL:initialize(url, shortcuts)
    local commonShortcuts = {
        { nil, nil, self.open, { url, "Open URL" } },
    }

    local mergedShortcuts = self:mergeShortcuts(shortcuts, commonShortcuts)

    self.url = url
    self.name = url
    self.shortcuts = mergedShortcuts

    local cheatsheetDescription = "Ki shortcut keybindings registered for url: "..self.url
    self.cheatsheet = Cheatsheet:new(self.path, cheatsheetDescription, mergedShortcuts)
end

--- URL:open(url)
--- Method
--- Opens the url
---
--- Parameters:
---  * `url` - the address of the url to open
---
--- Returns:
---   * None
function URL.open(url)
    if not url then return nil end

    hs.urlevent.openURL(url)
end

return URL
