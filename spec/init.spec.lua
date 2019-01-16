local say = require "say"
local assertions = require "spec.assertions"
local hammerspoonMocker = require "spec.mock-hammerspoon"

-- Set path to dependencies relative to this spec file
local luaVersion = _VERSION:match("%d+%.%d+")
local packagePath = "deps/share/lua/"..luaVersion

package.path = package.path..";../"..packagePath.."/?.lua"

assertions:init(say, assert)

-- Generate `requirePackage` function to mock external dependencies
local function requirePackageMocker(mocks)
    mocks = mocks or {}

    return function(name, isInternal)
        local mockLustache = {}
        local mockFsm = {
            create = function()
                return {}
            end
        }
        local mockMiddleclass = function()
            return {
                subclass = function()
                    return {
                        new = function() end
                    }
                end,
            }
        end

        if isInternal then
            return mock(dofile("src/"..name..".lua"))
        else
            if name == "fsm" then
                return mocks.fsm or mock(mockFsm)
            elseif name == "lustache" then
                return mocks.lustache or mock(mockLustache)
            elseif name == "middleclass" then
                return mocks.middleclass or mock(mockMiddleclass)
            end
        end
    end
end

-- Ki `init` method test suite
local function initKiTests()
    it("initializes the primary keydown event listener", function()
        local Ki = require("init")

        Ki:init()

        assert.has_property(Ki, "listener")
    end)

    it("handles keydown events", function()
        local Ki = require("init")
        local mockHs, hsMocks = hammerspoonMocker()
        local keyDownHandlerSpy = spy.new(function() end)
        local eventCallback = nil

        Ki._handleKeyDown = keyDownHandlerSpy
        hsMocks.eventtap.new = function(_, callback) eventCallback = callback end
        _G.hs = mock(mockHs({ eventtap = hsMocks.eventtap }))

        Ki:init()

        eventCallback()

        assert.spy(keyDownHandlerSpy).was.called()
    end)
end

-- Ki `start` method test suite
local function startKiTests()
    describe("start", function()
        it("should set a default status display", function()
            local ki = require("init")

            ki:init()
            ki:start()

            assert.has_property(ki, "statusDisplay")
        end)

        it("should set a custom status display", function()
            local ki = require("init")
            local testDisplay = { test = true }

            ki:init()
            ki.statusDisplay = testDisplay
            ki:start()

            assert.has_property(ki, "statusDisplay")
            assert.are.same(ki.statusDisplay, testDisplay)
        end)

        it("should set default transition and workflow events", function()
            local ki = require("init")

            ki:init()
            ki:start()

            assert.has_property(ki, "transitionEvents")
            assert.has_property(ki, "workflowEvents")
        end)

        it("should set custom workflow events", function()
            local ki = require("init")
            local testEvents = {
                entity = {
                    { nil, "test", function() end },
                    { {"shift"}, "test", function() end },
                },
            }

            ki:init()
            ki.workflowEvents = testEvents
            ki:start()

            assert.has_property(ki, "workflowEvents")
            assert.has_property(ki.workflowEvents, "entity")
            assert.has_value(ki.workflowEvents.entity, testEvents.entity[1])
            assert.has_value(ki.workflowEvents.entity, testEvents.entity[2])
        end)
    end)
end

-- Ki `stop` method test suite
local function stopKiTests()
    it("stops the primary keydown event listener", function()
        local Ki = require("init")
        local stopListenerSpy = spy.new(function() end)

        Ki.listener = { stop = stopListenerSpy }
        Ki:stop()

        assert.spy(stopListenerSpy).was.called()
    end)
end

-- Ki `mergeEvents` method test suite
local function mergeEventsTests()
    local tests = {
        {
            name = "appends new events",
            args = {
                "mode",
                {},
                { { nil, "a", {} } },
                _,
            },
            expectedResult = { { nil, "a", {} } },
        },
        {
            name = "shows error on shortcut conflicts",
            args = {
                "mode",
                { { { "ctrl" }, "a", {} } },
                { { { "ctrl" }, "a", {} } },
                false,
            },
            expectedResult = { { { "ctrl" }, "a", {} } },
            showsError = true,
        },
        {
            name = "overrides events on shortcut conflicts",
            args = {
                "mode",
                { { { "ctrl" }, "a", { "target" } } },
                { { { "ctrl" }, "a", { "override" } } },
                true,
            },
            expectedResult = { { { "ctrl" }, "a", { "override" } } },
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local Ki = require("init")
            local showErrorSpy = spy.new(function() end)
            local mockHs = hammerspoonMocker()
            local result = test.args[2]

            _G.hs = mock(mockHs({ showError = showErrorSpy }))

            Ki._mergeEvents(table.unpack(test.args))

            if test.showsError then
                assert.spy(showErrorSpy).was.called()
            end

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- Ki `_renderHotkeyText` method test suite
local function renderHotkeyTextTests()
    local tests = {
        {
            name = "renders hotkey text",
            args = { {}, "a" },
            expectedResult = "a",
        },
        {
            name = "renders modifier key text",
            args = { { cmd = true }, "a" },
            expectedResult = "⌘a",
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local Ki = require("init")
            local result = Ki._renderHotkeyText(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- Ki `_renderHotkeyText` method test suite
local function handleKeyDownTests()
    local mockEvent = function(flags, key)
        flags = flags or {}
        return {
            getFlags = function()
                return {
                    table.unpack(flags),
                    containExactly = function()
                        return #flags > 0
                    end,
                }
            end,
            getKeyCode = function()
                return key
            end,
        }
    end
    local mockSound = function(mockPlaySound)
        return {
            getByName = function()
                return {
                    volume = function()
                        return {
                            play = mockPlaySound
                        }
                    end,
                }
            end,
        }
    end

    local tests = {
        {
            name = "returns nil on non-existent event handler in desktop mode",
            mode = "desktop",
            workflowEvents = { desktop = {} },
            event = mockEvent({}, ""),
            expectedResult = nil,
        },
        {
            name = "plays sound on non-existent event handler for a non-desktop mode",
            mode = "test",
            workflowEvents = { test = {} },
            event = mockEvent({}, ""),
            shouldPlaySound = true,
            expectedResult = true,
        },
        {
            name = "notifies error on misconfigured event handler",
            mode = "test",
            workflowEvents = {
                test = {
                    { { "ctrl" }, "a", { "invalid", "event handler" } },
                },
            },
            event = mockEvent({ "ctrl" }, "a"),
            shouldNotifyError = true,
            expectedResult = true,
        },
        {
            name = "dispatches action through entity object",
            mode = "test",
            workflowEvents = {
                test = {
                    { { "ctrl" }, "a", { dispatchAction = spy.new(function() end) } },
                },
            },
            event = mockEvent({ "ctrl" }, "a"),
            expectedResult = true,
            expectedEventHandlerSpy = function(workflowEvents)
                return workflowEvents.test[1][3].dispatchAction
            end,
        },
        {
            name = "dispatches action through entity object and exits mode",
            mode = "test",
            workflowEvents = {
                test = {
                    {
                        { "ctrl" },
                        "a",
                        { dispatchAction = spy.new(function() return true end) },
                    },
                },
            },
            event = mockEvent({ "ctrl" }, "a"),
            shouldExitMode = true,
            expectedResult = true,
            expectedEventHandlerSpy = function(workflowEvents)
                return workflowEvents.test[1][3].dispatchAction
            end,
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local Ki = require("init")
            local mockHs = hammerspoonMocker()
            local mockKeycodes = {
                map = {
                    [test.event.getKeyCode()] = test.event.getKeyCode(),
                },
            }
            local mockNotifyError = spy.new(function() end)
            local mockPlaySound = spy.new(function() end)
            local mockExitMode = spy.new(function() end)

            Ki.workflowEvents = test.workflowEvents
            Ki.state = {
                current = test.mode,
                exitMode = mockExitMode,
            }
            Ki.createEntity = function()
                return { notifyError = mockNotifyError }
            end
            _G.hs = mock(mockHs({
                keycodes = mockKeycodes,
                sound = mockSound(mockPlaySound),
            }))

            local result = Ki:_handleKeyDown(test.event)

            if test.shouldNotifyError then
                assert.spy(mockNotifyError).was.called()
            end
            if test.shouldPlaySound then
                assert.spy(mockPlaySound).was.called()
            end
            if test.expectedEventHandlerSpy then
                assert.spy(test.expectedEventHandlerSpy(Ki.workflowEvents)).was.called()
            end
            if test.shouldExitMode then
                assert.spy(mockExitMode).was.called()
            end

            assert.are.same(test.expectedResult, result)
        end)
    end
end

describe("init.lua (#init)", function()
    local typeFunc = _G.type

    -- Set global shortcut indices
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_EVENT_HANDLER_INDEX = 3
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function ()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded.init = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
    end)

    after_each(function ()
        _G.hs = nil
        _G.requirePackage = nil
        _G.type = typeFunc
    end)

    describe("`init` method", initKiTests())
    describe("`start` method", startKiTests())
    describe("`stop` method", stopKiTests())
    describe("`_mergeEvents` method", mergeEventsTests())
    describe("`_renderHotkeyText` method", renderHotkeyTextTests())
    describe("`_handleKeyDown` method", handleKeyDownTests())
end)
