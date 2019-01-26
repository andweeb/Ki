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
        local mockMiddleclass = function()
            return {}
        end

        if isInternal then
            return mock(dofile("src/"..name..".lua"))
        else
            if name == "lustache" then
                return mocks.lustache or mock(mockLustache)
            elseif name == "middleclass" then
                return mocks.middleclass or mock(mockMiddleclass)
            end
        end
    end
end

local function initializeTests()
    it("initializes an entity", function()
        local entity = require("entity")

        entity:initialize("name", "shortcuts", true)

        assert.has_property(entity, "name")
        assert.has_property(entity, "autoExitMode")
        assert.has_property(entity, "shortcuts")
        assert.has_property(entity, "cheatsheet")
    end)
end

local function renderScriptTemplateTests()
    it("renders script template", function()
        local entity = require("entity")
        local fileReadSpy = spy.new(function() end)
        local fileCloseSpy = spy.new(function() end)
        local fileOpenSpy = spy.new(function()
            return {
                read = fileReadSpy,
                close = fileCloseSpy,
            }
        end)

        _G._backupIO = _G.io
        _G.io = { open = fileOpenSpy }

        entity.renderScriptTemplate("script")

        assert.spy(fileOpenSpy).was.called()
        assert.spy(fileReadSpy).was.called()
        assert.spy(fileCloseSpy).was.called()

        _G.io = _G._backupIO
    end)
end

local function notifyErrorTests()
    it("shows error notification", function()
        local entity = require("entity")
        local mockHs = hammerspoonMocker()
        local notifyShowSpy = spy.new(function() end)

        _G.hs = mock(mockHs({ notify = { show = notifyShowSpy } }))

        entity.notifyError("Error message", "details")

        assert.spy(notifyShowSpy).was.called()
    end)
end

local function getEventHandlerTests()
    local tests = {
        {
            name = "returns `nil` if there are no shortcuts",
            args = { {}, nil, "" },
            expectedResult = nil,
        },
        {
            name = "returns event handler from shortcut list by keys",
            args = { { { nil, "a", { eventHandler = true } } }, nil, "a" },
            expectedResult = { eventHandler = true },
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local entity = require("entity")
            local result = entity.getEventHandler(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

local function dispatchActionTests()
    it("returns `autoExitMode` on an event without a handler", function()
        local entity = require("entity")

        entity.autoExitMode = true
        entity.getEventHandler = function() end

        local result = entity:dispatchAction("test-mode", { flags = {}, keyName = "" })

        assert.are.same(true, result)
    end)

    it("invokes the shortcut event handler through a behavior", function()
        local entity = require("entity")
        local behaviorSpy = spy.new(function() end)

        entity.behaviors = { ["test-mode"] = behaviorSpy }
        entity.getEventHandler = function()
            return true
        end

        entity:dispatchAction("test-mode", { flags = {}, keyName = "" })

        assert.spy(behaviorSpy).was.called()
    end)
end

local function mergeShortcutsTests()
    local tests = {
        {
            name = "returns `toList` if `fromList` is empty",
            args = { {}, { nil, nil, {} } },
            expectedResult = { nil, nil, {} },
        },
        {
            name = "merges new shortcuts",
            args = { {{ nil, "b", {} }}, {{ nil, "a", {} }} },
            expectedResult = { { nil, "a", {} }, { nil, "b", {} } },
        },
        {
            name = "overrides shortcuts",
            args = { {{ nil, "a", { override = true } }}, {{ nil, "a", {} }} },
            expectedResult = { { nil, "a", { override = true } } },
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local entity = require("entity")
            local result = entity.mergeShortcuts(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

local function triggerAfterConfirmationTests()
    local tests = {
        {
            name = "triggers action on user confirmation",
            args = { "question", spy.new(function() end) },
            triggersAction = true,
            answer = "Confirm",
        },
    }

    for _, test in pairs(tests) do
        it(test.name, function()
            local actionSpy = test.args[2]
            local focusSpy = spy.new(function() end)
            local mockHs = hammerspoonMocker()
            local entity = require("entity")
            local mockDialog = {
                blockAlert = function() return test.answer end,
            }

            _G.hs = mock(mockHs({
                dialog = mockDialog,
                focus = focusSpy,
            }))

            entity.triggerAfterConfirmation(table.unpack(test.args))

            assert.spy(focusSpy).was.called(1)
            assert.spy(actionSpy).was.called(test.triggersAction and 1 or 0)
        end)
    end
end


local function showSelectionModalTests()
    local function createHsMocks(newChooser, newEventTap)
        local mockChooser = { new = newChooser }
        local mockEventTap = {
            new = newEventTap,
            event = { types = { keyDown = nil } },
        }

        return {
            eventtap = mockEventTap,
            chooser = mockChooser,
        }
    end

    it("listens for keydown events when modal is shown", function()
        local entity = require("entity")
        local mockHs = hammerspoonMocker()
        local mockStartListener = spy.new(function() end)
        local mockShowModalSpy = spy.new(function() end)
        local newChooser = function()
            return {
                choices = function() end,
                searchSubText = function() end,
                bgDark = function() end,
                show = mockShowModalSpy,
            }
        end
        local newEventTap = function()
            return { start = mockStartListener }
        end
        local hsMocks = createHsMocks(newChooser, newEventTap)

        _G.hs = mock(mockHs(hsMocks))

        entity.showSelectionModal()

        assert.spy(mockStartListener).was.called()
        assert.spy(mockShowModalSpy).was.called()
    end)

    it("stops selection listener and invoke the event handler on selection", function()
        local entity = require("entity")
        local mockHs = hammerspoonMocker()
        local mockStopListener = spy.new(function() end)
        local mockShowModalSpy = spy.new(function() end)
        local mockEventHandler = spy.new(function() end)
        local selectionCallback = nil
        local newChooser = function(callback)
            selectionCallback = callback
            return {
                choices = function() end,
                searchSubText = function() end,
                bgDark = function() end,
                show = mockShowModalSpy,
            }
        end
        local newEventTap = function()
            return {
                start = function() end,
                stop = mockStopListener,
            }
        end
        local hsMocks = createHsMocks(newChooser, newEventTap)

        _G.hs = mock(mockHs(hsMocks))

        entity.showSelectionModal(_, mockEventHandler)
        selectionCallback()

        assert.spy(mockStopListener).was.called()
        assert.spy(mockEventHandler).was.called()
    end)

    it("selects rows with shortcuts when the modal is visible", function()
        local entity = require("entity")
        local mockHs = hammerspoonMocker()
        local keydownCallback = nil
        local newChooser = function()
            return {
                choices = function() end,
                searchSubText = function() end,
                bgDark = function() end,
                show = function() end,
            }
        end
        local newEventTap = function(_, callback)
            keydownCallback = callback
            return {
                start = function() end,
            }
        end
        local mockEvent = {
            getFlags = function() return {} end,
            getKeyCode = function() return {} end,
        }
        local modalEventHandler = spy.new(function() end)
        local hsMocks = createHsMocks(newChooser, newEventTap)
        hsMocks.keycodes = { map = {} }

        _G.hs = mock(mockHs(hsMocks))

        entity.getEventHandler = function() return modalEventHandler end
        entity.showSelectionModal()

        local result = keydownCallback(mockEvent)

        assert.are.same(true, result)
        assert.spy(modalEventHandler).was.called()
    end)
end

-- Entity behavior methods test suite
local function behaviorTests()
    local tests = {
        {
            name = "returns auto-exit value from event handler",
            behavior = "default",
            args = { function() return _, false end },
            assertions = function(_, result)
                assert.is_false(result)
            end,
        },
        {
            name = "returns auto-exit value from entity",
            behavior = "default",
            args = { function() return _, nil end },
            setup = function(entity)
                entity.autoExitMode = true
            end,
            assertions = function(_, result)
                assert.is_true(result)
            end,
        },
    }

    -- Run behavior method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local entity = require("entity")

            if test.setup then test.setup(entity) end

            local result = entity.behaviors[test.behavior](entity, table.unpack(test.args))

            test.assertions(entity, result)
        end)
    end
end

-- Entity behavior metatable methods test suite
local function behaviorMetamethodTests()
    local tests = {
        {
            name = "overrides behaviors",
            args = { { default = {} }, { default = { overridden = true } } },
            metamethod = "__add",
            assertions = function(_, result)
                assert.are.same(result, { default = { overridden = true } })
            end,
        },
    }

    -- Run behavior method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local entity = require("entity")
            local metatable = getmetatable(entity.behaviors)
            local result = metatable[test.metamethod](table.unpack(test.args))

            test.assertions(entity, result)
        end)
    end
end

describe("entity.lua (#entity)", function()
    local printFunc = _G.print

    -- Set global shortcut indices
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_EVENT_HANDLER_INDEX = 3
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded.entity = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
        _G.print = function() end
    end)

    after_each(function()
        _G.hs = nil
        _G.requirePackage = nil
        _G.print = printFunc
    end)

    describe("behaviors", behaviorTests)
    describe("behavior metamethods", behaviorMetamethodTests)
    describe("`initialize` method", initializeTests)
    describe("`renderScriptTemplate` method", renderScriptTemplateTests)
    describe("`notifyError` method", notifyErrorTests)
    describe("`getEventHandler` method", getEventHandlerTests)
    describe("`dispatchAction` method", dispatchActionTests)
    describe("`mergeShortcuts` method", mergeShortcutsTests)
    describe("`triggerAfterConfirmation` method", triggerAfterConfirmationTests)
    describe("`showSelectionModal` method", showSelectionModalTests)
end)
