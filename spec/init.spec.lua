local assertions = require("spec.assertions")
local hsInitializer = require("spec.mock-hs")

assertions:init(require("say"), assert)

describe("init.lua", function()
    setup(function()
        -- Setup each test with a default mock hammerspoon environment
        _G.hs = mock(hsInitializer()())
    end)

    teardown(function()
        _G.hs = nil
    end)

    insulate("initialize ki", function()
        it("should expose public functions", function()
            local ki = require("init")
            local publicApi = {
                "start",
                "stop",
                "createEntityEvent",
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
        insulate("should set a default status display", function()
            local ki = require("init")

            ki:init()
            ki:start()

            assert.has_property(ki, "statusDisplay")
        end)

        insulate("should set a custom status display", function()
            local ki = require("init")
            local testDisplay = { test = true }

            ki:init()
            ki.statusDisplay = testDisplay
            ki:start()

            assert.has_property(ki, "statusDisplay")
            assert.are.same(ki.statusDisplay, testDisplay)
        end)

        insulate("should set default triggers", function()
            local ki = require("init")

            ki:init()
            ki:start()

            assert.has_property(ki, "triggers")
        end)

        insulate("should set custom triggers", function()
            local ki = require("init")
            local testEvents = {
                entity = {
                    { nil, "test", function() end },
                    { {"shift"}, "test", function() end },
                },
            }

            ki:init()
            ki.events = testEvents
            ki:start()

            assert.has_property(ki, "triggers")
            assert.has_property(ki.triggers, "entity")
            assert.has_value(ki.triggers.entity, testEvents.entity[1])
            assert.has_value(ki.triggers.entity, testEvents.entity[2])
        end)
    end)

    describe("ki event creation", function()
        insulate("should create new entity events using a helper function", function()
            local ki = require("init")
            local mockHs, hsMocks = hsInitializer()
            local eventHandler = spy.new(function() end)

            hsMocks.appfinder.appFromName = spy.new(function() end)
            _G.hs = mock(mockHs({ appfinder = hsMocks.appfinder }))

            ki.state = { exitMode = spy.new(function() end) }
            ki:createEntityEvent("test", eventHandler)

            assert.spy(eventHandler).was.called()
            assert.spy(ki.state.exitMode).was.called()
        end)

        insulate("should create the events metatable", function()
            local ki = require("init")
            local metatable = ki:createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { entity = {} }

            metatable.__add = spy.new(function() end)
            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(metatable.__add).was.called()
        end)

        insulate("should show errors on unexpected mode names when adding events", function()
            local ki = require("init")
            local metatable = ki:createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { unexpected = {} }
            local mockHs, hsMocks = hsInitializer()

            hsMocks.showError = spy.new(function() end)
            _G.hs = mock(mockHs({ showError = hsMocks.showError }))

            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(hsMocks.showError).was.called()
        end)

        insulate("should call function to merge events when adding events", function()
            local ki = require("init")
            local metatable = ki:createEventsMetatable()
            local defaultEvents = { entity = {} }
            local customEvents = { entity = {} }

            ki._mergeEvents = spy.new(function() end)
            setmetatable(defaultEvents, metatable)

            _ = defaultEvents + customEvents

            assert.spy(ki._mergeEvents).was.called()
        end)

        insulate("should merge events with conflicting hotkeys", function()
            local ki = require("init")
            local lhsEvent = { { nil, "t", "should be overwritten" } }
            local rhsEvent = { { nil, "t", "should overwrite the old value" } }

            ki:_mergeEvents("entity", lhsEvent, rhsEvent, true)

            assert.are.equal(lhsEvent[3], rhsEvent[3])
        end)

        insulate("should show errors for events with conflicting hotkeys", function()
            local ki = require("init")
            local lhsEvent = { { {"shift"}, "t", "test" } }
            local rhsEvent = { { {"shift"}, "t", "test" } }
            local mockHs, hsMocks = hsInitializer()

            hsMocks.showError = spy.new(function() end)
            _G.hs = mock(mockHs({ showError = hsMocks.showError }))

            ki:_mergeEvents("entity", lhsEvent, rhsEvent, false)

            assert.spy(hsMocks.showError).was.called()
        end)
    end)

    describe("fsm event callbacks", function()
        insulate("should create a generic `onstatechange` callback", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()

            assert.has_property(callbacks, "onstatechange")
        end)

        insulate("should record the event breadcrumb trail on fsm state changes", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()
            local eventName = "test event name"
            local keyName = "test key name"
            local flags = "test flags"

            callbacks.onstatechange(_, eventName, _, _, flags, keyName)

            assert.are.same(ki.trail.breadcrumb[1], {
                flags = flags,
                keyName = keyName,
                eventName = eventName,
            })
        end)

        insulate("should clear the event breadcrumb trail on state change to the initial state", function()
            local ki = require("init")
            local callbacks = ki:_createFsmCallbacks()
            local eventName = "test event name"
            local keyName = "test key name"
            local flags = "test flags"
            local nextState = "normal"

            ki.trail.breadcrumb = {
                {
                    flags = "previous flags",
                    keyName = "previous key name",
                    eventName = "previous event name",
                },
            }

            callbacks.onstatechange(_, eventName, _, nextState, flags, keyName)

            assert.are.same(ki.trail.breadcrumb, {})
        end)

        insulate("should create transition event-specific state change callbacks based on states table", function()
            local ki = require("init")

            ki.states = {
                { name = "enterEntityMode", from = "normal", to = "entity" },
                { name = "enterActionMode", from = "normal", to = "action" },
                { name = "exitMode", from = "entity", to = "normal" },
                { name = "exitMode", from = "action", to = "normal" },
            }

            local callbacks = ki:_createFsmCallbacks()

            for _, state in pairs(ki.states) do
                assert.has_property(callbacks, 'on'..state.name)
            end
        end)

        insulate("should save latest event in transition event-specific state change callback", function()
            local ki = require("init")
            local keyName = "test key name"
            local flags = "test flags"
            local eventName = 'onenterEntityMode'

            ki.statusDisplay = { show = function() end };
            ki.states = { { name = "enterEntityMode", from = "normal", to = "entity" } }

            local callbacks = ki:_createFsmCallbacks()

            assert.has_property(callbacks, eventName)

            callbacks.onenterEntityMode({}, _, _, _, flags, keyName)

            assert.are.same(ki.trail.lastEvent, {
                flags = flags,
                keyName = keyName,
                eventName = eventName,
            })
        end)

        insulate("should display current state in transition event-specific state change callback", function()
            local ki = require("init")
            local keyName = "test key name"
            local eventName = 'onenterEntityMode'
            local fsm = { current = "test state" }

            ki.statusDisplay = { show = spy.new(function() end) };
            ki.states = { { name = "enterEntityMode", from = "normal", to = "entity" } }

            local callbacks = ki:_createFsmCallbacks()

            assert.has_property(callbacks, eventName)

            callbacks.onenterEntityMode(fsm, _, _, _, _, keyName)

            assert.spy(ki.statusDisplay.show).was.called_with(ki.statusDisplay, fsm.current, keyName)
        end)
    end)

    describe("ki event handler", function()
        insulate("should call primary event handler", function()
            local mockHs, hsMocks = hsInitializer()

            -- Mock the eventtap constructor to return the event handler wrapper argument
            hsMocks.eventtap.new = function(_, handler)
                return function()
                    return handler
                end
            end

            _G.hs = mock(mockHs({ eventtap = hsMocks.eventtap }))

            local ki = require("init")
            local handleKeyDown = spy.new(function() end)
            ki._handleKeyDown = handleKeyDown

            ki:init()

            assert.has_property(ki, "listener")

            local handlerWrapper = ki.listener()
            handlerWrapper()

            assert.spy(handleKeyDown).was.called()
        end)

        insulate("should transition event in action mode to entity mode", function()
            local mockHs, hsMocks = hsInitializer()
            local enterEntityMode = spy.new(function() end)
            local ki = require("init")

            ki.triggers = { action = {} }
            ki.state = { current = "action", enterEntityMode = enterEntityMode }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(enterEntityMode).was.called()
        end)

        insulate("should play a sound when an unregistered event is triggered", function()
            local ki = require("init")
            local mockHs, hsMocks = hsInitializer()
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

            ki.triggers = { entity = {} }
            ki.state = { current = "entity" }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(play).was.called()
        end)

        insulate("should register keydown events", function()
            local mockHs, hsMocks = hsInitializer()
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
            ki.triggers = {
                [testState] = {
                    { nil, keyName, triggerSpy },
                },
            }

            ki:_handleKeyDown(hsMocks.event)

            assert.spy(triggerSpy).was.called()
        end)
    end)

    describe("stop", function()
        insulate("should stop the ki event listener", function()
            local mockHs, hsMocks = hsInitializer()
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
