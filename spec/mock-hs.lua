local util = require("util")

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
    keycodes = { map = {} },
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
    screen = {
        mainScreen = function()
            return {
                frame = function()
                    return { x = 0, y = 0, h = 0, w = 0 }
                end,
            }
        end
    },
    sound = {
        getByName = function()
            return {
                volume = function()
                    return {
                        play = function ()
                            return nil
                        end,
                    }
                end,
            }
        end,
    },
    showError = function()
        return nil
    end,
    styledtext = {
        new = function()
            return nil
        end,
    },
}

-- Init function that returns the `hs` mock object initializer and its default mocked fields
return function()
    -- Mock the Hammerspoon's `hs` environment object with either provided or pre-defined mocks
    local function mockHammerspoon(data)
        data = data or {}

        local hs = {}
        local hsMocks = util:clone(mocks)

        for name, mock in pairs(hsMocks) do
            hs[name] = data[name] or mock
        end

        return hs
    end

    -- Return primary mock object and expose mocked fields for granular composition in test files
    return mockHammerspoon, util:clone(mocks)
end

