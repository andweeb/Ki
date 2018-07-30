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

        if isInternal then
            return mock(dofile("src/"..name..".lua"))
        else
            if name == "fsm" then
                return mocks.fsm or mock(mockFsm)
            elseif name == "lustache" then
                return mocks.lustache or mock(mockLustache)
            end
        end
    end
end

describe("init.lua", function()
    before_each(function ()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
    end)

    after_each(function ()
        _G.hs = nil
        _G.requirePackage = nil
    end)

    describe("initialize ki", function()
        it("should expose public functions", function()
            local ki = require("init")
            local publicApi = {
                "extendEntity",
                "start",
                "stop",
            }

            for _, functionName in pairs(publicApi) do
                assert.has_property(ki, functionName)
                assert.are.equal(type(ki[functionName]), "function")
            end
        end)

        it("should initialize without errors", function()
            local ki = require("init")

            assert.has_no.errors(function() ki:init() end)
        end)

        it("should initialize finite state machine", function()
            local ki = require("init")

            ki:init()

            assert.has_property(ki, "state")
            assert.has_property(ki, "states")
            assert.has_property(ki, "listener")
        end)
    end)

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

            assert.has_property(ki, "transitions")
            assert.has_property(ki, "workflows")
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
            ki.workflows = testEvents
            ki:start()

            assert.has_property(ki, "workflows")
            assert.has_property(ki.workflows, "entity")
            assert.has_value(ki.workflows.entity, testEvents.entity[1])
            assert.has_value(ki.workflows.entity, testEvents.entity[2])
        end)
    end)

    describe("ki event configuration and creation", function()
        it("should create new entity workflow events using a helper function", function()
            local ki = require("init")
            local mockHs, hsMocks = hammerspoonMocker()
            local eventHandler = spy.new(function() end)

            hsMocks.appfinder.appFromName = spy.new(function() end)
            _G.hs = mock(mockHs({ appfinder = hsMocks.appfinder }))

            ki.state = { exitMode = spy.new(function() end) }
            ki:createEntityEventHandler("test", eventHandler)

            assert.spy(eventHandler).was.called()
            assert.spy(ki.state.exitMode).was.called()
        end)

        it("should create the events metatable", function()
            local ki = require("init")
            local metatable = ki:_createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { entity = {} }

            metatable.__add = spy.new(function() end)
            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(metatable.__add).was.called()
        end)

        it("should show errors on unexpected mode names when adding events", function()
            local ki = require("init")
            local metatable = ki:_createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { unexpected = {} }
            local mockHs, hsMocks = hammerspoonMocker()

            hsMocks.showError = spy.new(function() end)
            _G.hs = mock(mockHs({ showError = hsMocks.showError }))

            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(hsMocks.showError).was.called()
        end)

        it("should call function to merge events when adding events", function()
            local ki = require("init")
            local metatable = ki:_createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { entity = {} }

            ki._mergeEvents = spy.new(function() end)
            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(ki._mergeEvents).was.called()
        end)

        it("should merge events with conflicting hotkeys", function()
            local ki = require("init")
            local lhsEvent = { { nil, "t", "should be overwritten" } }
            local rhsEvent = { { nil, "t", "should overwrite the old value" } }

            ki._mergeEvents("entity", lhsEvent, rhsEvent, true)

            assert.are.equal(lhsEvent[3], rhsEvent[3])
        end)
    end)

    describe("ki state event callbacks", function()
        it("should create a generic state change callback", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()

            assert.has_property(callbacks, "on_enter_state")
        end)

        it("should render action hotkey text on enter state", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()
            local eventName = "test event name"
            local keyName = "test key name"
            local flags = "test flags"
            local fsm = { current = "test" }
            local action = {
                flags = { ctrl = true },
                keyName = "t",
            }

            ki:init()
            ki.listener = { isEnabled = function() return true end }
            ki.statusDisplay = { show = function() end };

            local showSpy = spy.on(ki.statusDisplay, "show")

            callbacks.on_enter_state(_, eventName, _, fsm.current, fsm, flags, keyName, action)

            assert.spy(showSpy).was.called()
        end)

        it("should clear out the event history on state change to the initial state", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()
            local eventName = "test event name"
            local keyName = "test key name"
            local flags = "test flags"
            local fsm = { current = "normal" }

            ki:init()
            ki.listener = { isEnabled = function() return true end }
            ki.statusDisplay = { show = function() end };
            ki.history.workflow.events = {
                {
                    flags = "previous flags",
                    keyName = "previous key name",
                    eventName = "previous event name",
                },
            }

            callbacks.on_enter_state(_, eventName, _, fsm.current, fsm, flags, keyName)

            assert.are.same(ki.history.workflow.events, {})
        end)
    end)

    describe("ki selection modal", function()
        it("should show selection modal", function()
            local ki = require("init")
            local mockHs, hsMocks = hammerspoonMocker()
            local showListenerSpy = spy.new(function() end)

            hsMocks.chooser.new = function()
                return {
                    show = showListenerSpy,
                    choices = function() end,
                    bgDark = function() end,
                }
            end
            _G.hs = mock(mockHs({ chooser = hsMocks.chooser }))

            ki:showSelectionModal()

            assert.spy(showListenerSpy).was.called()
        end)

        it("should select a choice", function()
            local ki = require("init")
            local choice = "test choice"
            local mockHs, hsMocks = hammerspoonMocker()
            local selectSpy = spy.new(function() end)
            local mockCallback = nil

            ki.history.workflow.events = {{ }}
            hsMocks.chooser.new = function(callback)
                mockCallback = callback
                return {
                    show = function() end,
                    choices = function() end,
                    bgDark = function() end,
                }
            end
            _G.hs = mock(mockHs({ chooser = hsMocks.chooser }))

            ki:showSelectionModal({}, selectSpy)
            mockCallback(choice)

            assert.spy(selectSpy).was_called_with(choice)
        end)

        insulate("should enable keyboard shortcuts for the selection modal", function()
            local function mockSelectionHs(selectedIndex, shortcutKeyName)
                local mockHs, hsMocks = hammerspoonMocker()
                local mockEvent = {
                    getFlags = function()
                        return {
                            containExactly = function()
                                return true
                            end
                        }
                    end,
                    getKeyCode = function()
                        return shortcutKeyName
                    end,
                };
                local mockChooser = {
                    show = function() end,
                    choices = function() end,
                    bgDark = function() end,
                    selectedRow = function()
                        return selectedIndex
                    end,
                }

                hsMocks.eventtap.new = function(_, handler)
                    return {
                        -- Trigger callback by mocking `start()`
                        start = function()
                            handler(mockEvent)
                        end,
                    }
                end
                hsMocks.chooser.new = function()
                    return mockChooser
                end
                spy.on(mockChooser, "selectedRow")

                return mockChooser, mockHs({
                    eventtap = hsMocks.eventtap,
                    chooser = hsMocks.chooser,
                    keycodes = {
                        map = {
                            [shortcutKeyName] = shortcutKeyName,
                        },
                    },
                })
            end

            it("should select the lower row with a shortcut", function()
                local ki = require("init")
                local mockChooser, mockHs = mockSelectionHs(1, "j")

                _G.hs = mock(mockHs)

                ki:showSelectionModal({}, function() end)

                assert.spy(mockChooser.selectedRow).was_called(_, 2)
            end)

            it("should select the upper row with a shortcut", function()
                local ki = require("init")
                local mockChooser, mockHs = mockSelectionHs(1, "k")

                _G.hs = mock(mockHs)

                ki:showSelectionModal({}, function() end)

                assert.spy(mockChooser.selectedRow).was_called(_, 0)
            end)
        end)

    end)

    describe("ki event handler", function()
        it("should transition event in action mode to entity mode", function()
            local _, hsMocks = hammerspoonMocker()
            local enterEntityMode = spy.new(function() end)
            local ki = require("init")

            ki.workflows = { action = {} }
            ki.state = { current = "action", enterEntityMode = enterEntityMode }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(enterEntityMode).was.called()
        end)

        it("should play a sound when an unregistered event is triggered", function()
            local ki = require("init")
            local mockHs, hsMocks = hammerspoonMocker()
            local play = spy.new(function() end)

            hsMocks.sound = {
                getByName = function()
                    return {
                        volume = function()
                            return {
                                play = play,
                            }
                        end,
                    }
                end,
            }

            _G.hs = mock(mockHs({ sound = hsMocks.sound }))

            ki.workflows = { entity = {} }
            ki.state = { current = "entity" }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(play).was.called()
        end)

        it("should register keydown events", function()
            local mockHs, hsMocks = hammerspoonMocker()
            local keyName = "keycode"

            -- Mock keycodes to return an expected keycode name
            hsMocks.keycodes.map = { [keyName] = keyName }
            hsMocks.event.getKeyCode = function()
                return keyName
            end

            _G.hs = mock(mockHs({ keycodes = hsMocks.keycodes }))

            local ki = require("init")
            local testState = "entity"
            local triggerSpy = spy.new(function() end)

            ki:init()
            ki:start()
            ki.state.current = testState
            ki.workflows = {
                [testState] = {
                    { nil, keyName, triggerSpy },
                },
            }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(triggerSpy).was.called()
        end)
    end)

    describe("stop", function()
        it("should stop the ki event listener", function()
            local mockHs, hsMocks = hammerspoonMocker()
            local stopListenerSpy = spy.new(function() end)
            local ki = require("init")

            hsMocks.eventtap.new = function()
                return {
                    stop = stopListenerSpy,
                }
            end

            -- Mock eventtap listener stop function
            _G.hs = mock(mockHs({ eventtap = hsMocks.eventtap }))

            ki:init()
            ki:stop()

            assert.spy(stopListenerSpy).was.called()
        end)
    end)
end)
