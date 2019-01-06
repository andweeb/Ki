local say = require("say")
local assertions = require("spec.assertions")
local hammerspoonMocker = require("spec.mock-hammerspoon")

assertions:init(say, assert)

-- Generate `requirePackage` function to mock external dependencies
local function requirePackageMocker(mocks)
    mocks = mocks or {}

    return function(name, isInternal)
        local mockLustache = {
            render = function() end
        }

        if isInternal then
            return mock(dofile("src/"..name..".lua"))
        else
            if name == "lustache" then
                return mocks.lustache or mock(mockLustache)
            end
        end
    end
end

-- Cheatsheet `init` method test suite
local function initMethodTests()
    local tests = {
        {
            name = "initializes a cheatsheet with the default view",
            args = {
                "name",
                "description",
                {},
            },
        },
        {
            name = "initializes a cheatsheet with a custom view",
            args = {
                "name",
                "description",
                {},
                { custom = true },
            },
        },
    }

    -- Run `init` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local cheatsheet = require("cheatsheet")

            cheatsheet:init(table.unpack(test.args))

            assert.has_property(cheatsheet, "name")
            assert.has_property(cheatsheet, "description")
            assert.has_property(cheatsheet, "shortcuts")
            assert.has_property(cheatsheet, "view")
        end)
    end
end

-- Cheatsheet `show` method test suite
local function showMethodTests()
    local tests = {
        {
            name = "shows the cheatsheet",
            assertions = function(_, spies)
                assert.spy(spies.viewShow).was.called()
            end
        },
        {
            name = "starts a listener for cheatsheet shortcuts",
            setup = function(_, hsMocks, spies)
                spies.startListener = spy.new(function() end)
                spies.stopListener = spy.new(function() end)

                hsMocks.eventtap.new = function()
                    return {
                        start = spies.startListener,
                    }
                end
            end,
            assertions = function(_, spies)
                assert.spy(spies.startListener).was.called()
            end
        },
        {
            name = "retrieves app image for application entities",
            setup = function(_, hsMocks, spies)
                local mockApp = {
                    bundleID = function() end,
                }

                spies.imageFromAppBundle = spy.new(hsMocks.image.imageFromAppBundle)

                hsMocks.application.get = function() return mockApp end
                hsMocks.image.imageFromAppBundle = spies.imageFromAppBundle
            end,
            assertions = function(_, spies)
                assert.spy(spies.imageFromAppBundle).was.called()
            end
        },
        {
            name = "hides cheatsheet and stops listener on escape key down event",
            setup = function(_, hsMocks, spies)
                spies.startListener = spy.new(function() end)
                spies.stopListener = spy.new(function() end)

                hsMocks.keycodes.map = { escape = "escape" }
                hsMocks.eventtap.new = function(_, eventCallback)
                    spies.eventCallback = eventCallback
                    return {
                        start = spies.startListener,
                        stop = spies.stopListener,
                    }
                end
            end,
            assertions = function(_, spies)
                local mockEvent = {
                    getKeyCode = function() return "escape" end,
                    getFlags = function()
                        return {
                            containExactly = function() return true end
                        }
                    end,
                }

                spies.eventCallback(mockEvent)

                assert.spy(spies.startListener).was.called()
                assert.spy(spies.viewHide).was.called()
                assert.spy(spies.stopListener).was.called()
            end
        },
        {
            name = "creates basic shortcut blocks for the cheatsheet view",
            mockShortcuts = {
                { nil, "a", function() end },
                { nil, "b", function() end },
                { nil, "c", function() end },
            },
            setup = function(cheatsheet)
                cheatsheet = mock(cheatsheet) -- luacheck: ignore
            end,
            assertions = function(cheatsheet)
                assert.spy(cheatsheet._createShortcutBlocks).was.called()
            end
        },
        {
            name = "creates a shortcut block with shortcut metadata for the cheatsheet view",
            mockShortcuts = {
                { nil, "a", function() end, { "Shortcuts", "Metadata A" } },
                { nil, "b", function() end, { "Shortcuts", "Metadata B" } },
                { nil, "c", function() end, { "Shortcuts", "Metadata C" } },
            },
            setup = function(cheatsheet)
                cheatsheet = mock(cheatsheet) -- luacheck: ignore
            end,
            assertions = function(cheatsheet)
                assert.spy(cheatsheet._createShortcutBlocks).was.called()
            end
        },
        {
            name = "creates a shortcut block with a modkey glyph",
            mockShortcuts = {
                { { "shift" }, "a", function() end, { "Shortcuts", "Metadata" } },
            },
            setup = function(cheatsheet)
                cheatsheet = mock(cheatsheet) -- luacheck: ignore
            end,
            assertions = function(cheatsheet)
                assert.spy(cheatsheet._createShortcutBlocks).was.called()
            end
        },
        {
            name = "creates multiple shortcut blocks",
            mockShortcuts = {
                { { "shift" }, "a", function() end, { "Shortcuts A", "Metadata" } },
                { { "shift" }, "b", function() end, { "Shortcuts A", "Metadata" } },
                { { "cmd" }, "a", function() end, { "Shortcuts B", "Metadata" } },
                { { "cmd" }, "b", function() end, { "Shortcuts B", "Metadata" } },
            },
            setup = function(cheatsheet)
                cheatsheet = mock(cheatsheet) -- luacheck: ignore
            end,
            assertions = function(cheatsheet)
                assert.spy(cheatsheet._createShortcutBlocks).was.called()
            end
        },
    }

    -- Run `show` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs, hsMocks = hammerspoonMocker()
            local cheatsheet = require("cheatsheet")
            local spies = {
                viewWindowTitle = spy.new(function() end),
                viewFrame = spy.new(function()
                    return function()
                        return { x = 0, y = 0, h = 0, w = 0 }
                    end
                end),
                viewHtml = spy.new(function() end),
                viewShow = spy.new(function() end),
                viewHide = spy.new(function() end),
            }
            local mockView = {
                windowTitle = spies.viewWindowTitle,
                frame = spies.viewFrame,
                html = spies.viewHtml,
                show = spies.viewShow,
                hide = spies.viewHide,
            }
            local mockShortcuts = test.mockShortcuts or {}

            if test.setup then test.setup(cheatsheet, hsMocks, spies) end

            -- Mock eventtap listener stop function
            _G.hs = mock(mockHs({ eventtap = hsMocks.eventtap }))

            cheatsheet:init("name", "description", mockShortcuts, mockView)
            cheatsheet:show()

            test.assertions(cheatsheet, spies, mockView)
        end)
    end
end

describe("cheatsheet.lua (#cheatsheet)", function()
    -- Set global shortcut indices
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function ()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded.cheatsheet = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
    end)

    after_each(function ()
        _G.hs = nil
        _G.requirePackage = nil
    end)

    describe("`init` method", function() initMethodTests() end)
    describe("`show` method", function() showMethodTests() end)
end)
