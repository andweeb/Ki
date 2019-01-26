local util = require "util"

-- Define generic mocks of any `hs` functions used in Ki
local mocks = {
    appfinder = {
        appFromName = function()
            return nil
        end
    },
    application = {
        get = function()
            return nil
        end,
        enableSpotlightForNameSearches = function()
            return nil
        end,
        infoForBundlePath = function()
            return nil
        end,
        launchOrFocus = function()
            return nil
        end,
    },
    canvas = {
        new = function()
            return {
                appendElements = function()
                    return {
                        show = function()
                            return nil
                        end,
                    }
                end,
            }
        end,
    },
    chooser = {
        new = function()
            return nil
        end,
    },
    dialog = function()
        return nil
    end,
    dir = function()
        return nil
    end,
    displayName = function()
        return nil
    end,
    dockicon = {
        hide = function()
            return nil
        end
    },
    drawing = {
        windowLevels = {
            modalPanel = nil,
        },
    },
    execute = function()
        return nil
    end,
    focus = function()
        return nil
    end,
    fs = {
        attributes = function()
            return nil
        end,
        fileUTI = function()
            return nil
        end,
        pathToAbsolute = function()
            return nil
        end,
    },
    image = {
        iconForFileType = function()
            return nil
        end,
        imageFromAppBundle = function()
            return {
                encodeAsURLString = function()
                    return nil
                end
            }
        end
    },
    keycodes = { map = {} },
    event = {
        getKeyCode = function()
            return ""
        end,
        getFlags = function()
            return {
                containExactly = function()
                    return true
                end
            }
        end,
    },
    eventtap = {
        new = function()
            return {
                start = function()
                    return nil
                end,
                isEnabled = function()
                    return nil
                end,
                stop = function()
                    return nil
                end,
            }
        end,
        event = {
            types = {
                keyDown = nil,
            },
        },
    },
    notify = {
        show = function()
            return nil
        end,
    },
    open = function() return nil end,
    osascript = {
        applescript = function()
            return nil
        end,
    },
    screen = {
        mainScreen = function()
            return {
                fullFrame = function()
                    return { x = 0, y = 0, h = 0, w = 0 }
                end,
                frame = function()
                    return { x = 0, y = 0, h = 0, w = 0 }
                end,
            }
        end
    },
    showError = function()
        return nil
    end,
    sound = {
        getByName = function()
            return {
                volume = function()
                    return {
                        play = function()
                            return nil
                        end,
                    }
                end,
            }
        end,
    },
    styledtext = {
        new = function()
            return nil
        end,
    },
    timer = {
        doAfter = function()
            return nil
        end,
    },
    webview = {
        new = function()
            return {
                windowStyle = function() return nil end,
                level = function() return nil end,
                darkMode = function() return nil end,
                shadow = function() return nil end,
            }
        end,
    },
    window = function()
        return {
            focus = function() return nil end,
            focusTab = function() return nil end,
        }
    end,
}

-- Init function that returns the `hs` mock object initializer and its default mocked fields
return function()
    -- Mock the Hammerspoon's `hs` environment object with either provided or pre-defined mocks
    local hsMocks = util:clone(mocks)
    local function mockHammerspoon(data)
        data = data or {}

        local hs = {}
        for name, mock in pairs(hsMocks) do
            hs[name] = data[name] or mock
        end

        return hs
    end

    -- Return primary mock object and expose mocked fields for granular composition in test files
    return mockHammerspoon, hsMocks
end

