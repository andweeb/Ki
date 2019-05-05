local say = require("say")
local assertions = require("spec.assertions")
local hammerspoonMocker = require("spec.mock-hammerspoon")

assertions:init(say, assert)

-- Generate `requirePackage` function to mock external dependencies
local function requirePackageMocker(mocks)--{{{
    mocks = mocks or {}

    return function(name, isInternal)
        local mockMiddleclass = function()
            return {
                subclass = function()
                    return {}
                end
            }
        end

        if isInternal then
            return mock(dofile("src/"..name..".lua"))
        else
            if name == "middleclass" then
                return mocks.middleclass or mock(mockMiddleclass)
            end
        end
    end
end--}}}

-- URL `initialize` method test suite
local function initializeTests()--{{{
    it("initializes a url", function()
        local URL = require("url")

        URL.mergeShortcuts = function() return {} end

        URL:initialize("url", {})

        assert.has_property(URL, "url")
        assert.has_property(URL, "shortcuts")
        assert.has_property(URL, "cheatsheet")
    end)
end--}}}

-- URL `getDomain` method test suite
local function getDomainTests()--{{{
    local tests = {
        {
            name = "copies the file to a destination folder successfully",
            args = { "https://www.google.com?q=ki" },
            expectedResult = "google.com",
        },
    }

    -- Run `getDomain` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local URL = require("url")
            local result = URL.getDomain(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end--}}}

-- URL `open` method test suite
local function openTests()--{{{
    local tests = {
        {
            name = "does not open if URL is nil",
            args = { nil },
            opensURL = false
        },
        {
            name = "opens url",
            args = { "www.google.com" },
            opensURL = true
        },
    }

    -- Run `open` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local openSpy = spy.new(function() end)

            local URL = require("url")

            _G.hs.urlevent = { openURL = openSpy }

            URL.open(table.unpack(test.args))

            assert.spy(openSpy).was.called(test.opensURL and 1 or 0)
        end)
    end
end--}}}

-- URL `getSelectionItems` method test suite
local function getSelectionItemsTests()--{{{
    local tests = {
        {
            name = "returns empty list when there are no paths",
            paths = {},
            expectedResult = {},
        },
        {
            name = "returns basic url selection items",
            paths = {
                "https://github.com/andweeb",
                "https://github.com/aaparella",
            },
            expectedResult = {
                {
                    text = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                },
                {
                    text = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                },
            },
        },
        {
            name = "returns basic url selection items with favicon images",
            paths = {
                "https://github.com/andweeb",
                "https://github.com/aaparella",
            },
            domain = "github.com",
            imageFromURL = "favicon",
            displaySelectionModalIcons = true,
            expectedResult = {
                {
                    text = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                    image = "favicon",
                },
                {
                    text = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                    image = "favicon",
                },
            },
        },
        {
            name = "returns url selection items from sub-paths",
            url = "https://github.com",
            paths = { "/andweeb", "/aaparella" },
            expectedResult = {
                {
                    text = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                },
                {
                    text = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                },
            },
        },
        {
            name = "returns named url selection items",
            paths = {
                { name = "Andrew's Github Profile", path = "https://github.com/andweeb" },
                { name = "Alex's Github Profile", path = "https://github.com/aaparella" },
            },
            expectedResult = {
                {
                    text = "Andrew's Github Profile",
                    subText = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                },
                {
                    text = "Alex's Github Profile",
                    subText = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                },
            },
        },
        {
            name = "returns named url selection items with favicon images",
            paths = {
                { name = "Andrew's Github Profile", path = "https://github.com/andweeb" },
                { name = "Alex's Github Profile", path = "https://github.com/aaparella" },
            },
            domain = "github.com",
            imageFromURL = "favicon",
            displaySelectionModalIcons = true,
            expectedResult = {
                {
                    text = "Andrew's Github Profile",
                    subText = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                    image = "favicon",
                },
                {
                    text = "Alex's Github Profile",
                    subText = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                    image = "favicon",
                },
            },
        },
        {
            name = "returns named url selection items from sub-paths",
            url = "https://github.com",
            paths = {
                { name = "Andrew's Github Profile", path = "/andweeb" },
                { name = "Alex's Github Profile", path = "/aaparella" },
            },
            expectedResult = {
                {
                    text = "Andrew's Github Profile",
                    subText = "https://github.com/andweeb",
                    url = "https://github.com/andweeb",
                },
                {
                    text = "Alex's Github Profile",
                    subText = "https://github.com/aaparella",
                    url = "https://github.com/aaparella",
                },
            },
        },
    }

    -- Run `getSelectionItems` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            _G.hs = mock(mockHs({
                image = {
                    imageFromURL = function()
                        return test.imageFromURL
                    end
                },
            }))

            local URL = require("url")

            URL.url = test.url
            URL.paths = test.paths
            URL.getDomain = function() return test.domain end
            URL.displaySelectionModalIcons = test.displaySelectionModalIcons or false

            local result = URL:getSelectionItems()

            assert.are.same(test.expectedResult, result)
        end)
    end
end--}}}

-- URL `default` behavior function test suite
local function defaultBehaviorTests()--{{{
    local test = {
        url = "https://www.google.com",
        expectedResult = true,
    }

    it("triggers the event handler and auto-exits mode", function()
        local URL = require("url")
        local eventHandlerSpy = spy.new(function() end)

        URL.url = test.applicationName

        assert.are.same(type(URL.behaviors.default), "function")

        local result = URL.behaviors.default(URL, eventHandlerSpy)

        assert.are.same(test.expectedResult, result)
        assert.spy(eventHandlerSpy).was.called()
    end)
end--}}}

-- URL `select` mode behavior function test suite
local function selectBehaviorTests()--{{{
    local behaviorTests = {
        {
            name = "returns when there are no selection items",
            showSelectionModalCallCount = 0,
            eventHandlerCallCount = 0,
            expectedResult = true,
        },
        {
            name = "shows selection modal and does not trigger handler when there is no selection",
            selectionItems = {
                "https://github.com/andweeb",
                "https://github.com/aaparella",
            },
            choice = nil,
            showSelectionModalCallCount = 1,
            eventHandlerCallCount = 0,
            expectedResult = true,
        },
        {
            name = "triggers event handler on selection",
            selectionItems = {
                "https://github.com/andweeb",
                "https://github.com/aaparella",
            },
            choice = {
                text = "https://github.com/aaparella",
                url = "https://github.com/aaparella",
            },
            showSelectionModalCallCount = 1,
            eventHandlerCallCount = 1,
            expectedResult = true,
        },
    }

    -- Run `select` mode behavior method tests
    for _, test in pairs(behaviorTests) do
        it(test.name, function()
            local URL = require("url")
            local eventHandlerSpy = spy.new(function() end)
            local showSelectionModalSpy = spy.new(function(_, callback)
                callback(test.choice)
            end)

            URL.url = test.url
            URL.getSelectionItems = function() return test.selectionItems end

            -- Mock show selection modal callback to immediately trigger an item selection
            URL.showSelectionModal = showSelectionModalSpy

            assert.are.same(type(URL.behaviors.select), "function")

            local result = URL.behaviors.select(URL, eventHandlerSpy)

            assert.are.same(test.expectedResult, result)
            assert.spy(eventHandlerSpy).was.called(test.eventHandlerCallCount)
            assert.spy(showSelectionModalSpy).was.called(test.showSelectionModalCallCount)
        end)
    end
end--}}}

-- URL `url` mode behavior function test suite
local function urlBehaviorTests()--{{{
    local behaviorTests = {
        {
            name = "triggers the default behavior",
            workflow = {},
            triggersDefaultBehavior = true,
        },
        {
            name = "triggers the select behavior",
            workflow = { { mode = "select" } },
            triggersSelectBehavior = true,
        },
    }

    -- Run `url` mode behavior method tests
    for _, test in pairs(behaviorTests) do
        it(test.name, function()
            local URL = require("url")

            URL.url = test.url
            URL.behaviors.select = spy.new(function() end)
            URL.behaviors.default = spy.new(function() end)

            assert.are.same(type(URL.behaviors.url), "function")

            URL.behaviors.url(URL, _, _, _, test.workflow)

            if test.triggersDefaultBehavior then
                assert.spy(URL.behaviors.default).was.called()
            end
            if test.triggersSelectBehavior then
                assert.spy(URL.behaviors.select).was.called()
            end
        end)
    end
end--}}}

describe("url.lua (#url)", function()
    -- Set globals
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_EVENT_HANDLER_INDEX = 3
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded.file = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
    end)

    after_each(function()
        _G.hs = nil
        _G.requirePackage = nil
    end)

    describe("`initialize` method", initializeTests)
    describe("`open` method", openTests)
    describe("`getDomain` method", getDomainTests)
    describe("`getSelectionItems` method", getSelectionItemsTests)
    describe("`default` behavior function", defaultBehaviorTests)
    describe("`select` behavior function", selectBehaviorTests)
    describe("`url` behavior function", urlBehaviorTests)
end)
