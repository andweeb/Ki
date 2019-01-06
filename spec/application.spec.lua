local say = require("say")
local match = require("luassert.match")
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
            return {
                subclass = function()
                    return {}
                end
            }
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

-- Entity `createMenuItemEvent` method test suite
local function createMenuItemEventTests()
    local mockApp = {
        selectMenuItem = spy.new(function() end),
        activate = function() end,
    }

    -- Clear out spies
    before_each(function()
        mockApp.selectMenuItem:clear()
    end)

    local tests = {
        {
            name = "selects menu item without options",
            methodArgs = { "Menu Item" },
            eventHandlerArgs = { mockApp },
            selectMenuItemCall = {
                args = { match._, "Menu Item", match._ },
                count = 1,
            },
            focusCall = {
                count = 0,
            },
        },
        {
            name = "focuses application before selecting menu item",
            methodArgs = { "Menu Item", { focusBefore = true } },
            eventHandlerArgs = { mockApp, { text = "choice" } },
            selectMenuItemCall = {
                args = { match._, "Menu Item", match._ },
                count = 1,
            },
            focusCall = {
                args = { match._, { text = "choice" } },
                count = 1,
            },
        },
        {
            name = "focuses application after selecting menu item",
            methodArgs = { "Menu Item", { focusAfter = true } },
            eventHandlerArgs = { mockApp, { text = "choice" } },
            selectMenuItemCall = {
                args = { match._, "Menu Item", match._ },
                count = 1,
            },
            focusCall = {
                args = { match._, { text = "choice" } },
                count = 1,
            },
        },
        {
            name = "selects first toggleable menu item",
            methodArgs = { { "Menu Item 1", "Menu Item 2" }, { isToggleable = true } },
            eventHandlerArgs = {
                {
                    selectMenuItem = spy.new(function() return true end),
                    activate = function() end,
                },
            },
            selectMenuItemCall = {
                args = { match._, "Menu Item 1", match._ },
                count = 1,
            },
            focusCall = {
                count = 0,
            },
        },
        {
            name = "selects subsequent toggleable menu item if the first returns false",
            methodArgs = { { "Menu Item 1", "Menu Item 2" }, { isToggleable = true } },
            eventHandlerArgs = {
                {
                    selectMenuItem = spy.new(function() return false end),
                    activate = function() end,
                },
            },
            selectMenuItemCall = {
                args = { match._, "Menu Item 2", match._ },
                count = 2,
            },
            focusCall = {
                count = 0,
            },
        },
    }

    -- Run `createMenuItemEvent` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local application = require("application")
            local focusSpy = spy.on(application, "focus")
            local eventHandler = application.createMenuItemEvent(table.unpack(test.methodArgs))
            local selectMenuItemSpy = test.eventHandlerArgs[1].selectMenuItem

            assert.are.equal(type(eventHandler), "function")

            eventHandler(table.unpack(test.eventHandlerArgs))

            assert.spy(focusSpy).was.called(test.focusCall.count)
            assert.spy(selectMenuItemSpy).was.called(test.selectMenuItemCall.count)

            if test.focusCall.count > 0 then
                local expectedArgs = test.focusCall.args
                assert.spy(focusSpy).was_called_with(table.unpack(expectedArgs))
            end

            if test.selectMenuItemCall.count > 0 then
                local expectedArgs = test.selectMenuItemCall.args
                assert.spy(selectMenuItemSpy).was_called_with(table.unpack(expectedArgs))
            end
        end)
    end
end

-- Entity `focus` method test suite
local function focusTests()
    local mockApp = {
        activate = spy.new(function() end),
    }

    -- Clear out spies
    before_each(function()
        mockApp.activate:clear()
    end)

    local tests = {
        {
            name = "activates the application when choice is nil",
            args = { mockApp },
            activateCallCount = 1,
            focusCallCount = 0,
            focusTabCall = {
                count = 0,
            },
        },
        {
            name = "focuses the application window",
            args = { mockApp, { text = "choice" } },
            activateCallCount = 0,
            focusCallCount = 1,
            focusTabCall = {
                count = 1,
                args = { match._, match._ },
            },
        },
        {
            name = "focuses the specific application window tab",
            args = { mockApp, { text = "choice", tabIndex = 1337 } },
            activateCallCount = 0,
            focusCallCount = 1,
            focusTabCall = {
                count = 1,
                args = { match._, 1337 },
            },
        },
    }

    -- Run `focus` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local application = require("application")

            local activateSpy = test.args[1].activate
            local focusSpy = spy.new(function() return true end)
            local focusTabSpy = spy.new(function() return true end)
            local mockWindow = function()
                return {
                    focus = focusSpy,
                    focusTab = focusTabSpy,
                }
            end

            _G.hs = mock(mockHs({ window = mockWindow }))

            application.focus(table.unpack(test.args))

            assert.spy(activateSpy).was.called(test.activateCallCount)
            assert.spy(focusSpy).was.called(test.focusCallCount)
            assert.spy(focusTabSpy).was.called(test.focusTabCall.count)

            if test.focusTabCall.count > 0 then
                local expectedArgs = test.focusTabCall.args
                assert.spy(focusTabSpy).was_called_with(table.unpack(expectedArgs))
            end
        end)
    end
end

-- Entity `getApplication` method test suite
local function getApplicationTests()
    local tests = {
        {
            name = "gets the hammerspoon application object from name",
            isAppRunning = true,
            applicationName = "Test",
            launchOrFocusCallCount = 0,
            appFromNameCallCount = 0,
            expectedResult = { name = "Test" },
        },
        {
            name = "launches the application and finds the app by name",
            isAppRunning = false,
            applicationName = "Test",
            launchOrFocusCallCount = 1,
            appFromNameCallCount = 1,
            expectedResult = { name = "Test" },
        },
    }

    -- Run `getApplication` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local application = require("application")
            local launchOrFocusSpy = spy.new(function() end)
            local appFromNameSpy = spy.new(function(name)
                return { name = name }
            end)
            local mockHsApplication = {
                get = function(name)
                    return test.isAppRunning and { name = name } or nil
                end,
                launchOrFocus = launchOrFocusSpy,
            }
            local mockAppfinder = {
                appFromName = appFromNameSpy,
            }

            application.name = test.applicationName

            _G.hs = mock(mockHs({
                application = mockHsApplication,
                appfinder = mockAppfinder,
            }))

            local result = application:getApplication()

            assert.are.same(test.expectedResult, result)
            assert.spy(launchOrFocusSpy).was.called(test.launchOrFocusCallCount)
            assert.spy(appFromNameSpy).was.called(test.launchOrFocusCallCount)

            if test.launchOrFocusCallCount > 0 then
                assert.spy(launchOrFocusSpy).was.called_with(test.applicationName)
            end
            if test.appFromNameCallCount > 0 then
                assert.spy(appFromNameSpy).was.called_with(test.applicationName)
            end
        end)
    end
end

-- Entity `getMenuItemList` method test suite
local function getMenuItemListTests()
    local tests = {
        {
            name = "gets menu item list from menu item path",
            menuItems = { {
                AXTitle = "File",
                AXChildren = { { {
                    AXTitle = "Open Recent",
                    AXChildren = { {
                        { AXTitle = "test.txt" },
                        { AXTitle = "text.txt" },
                    } },
                } } },
            } },
            menuItemPath = { "File", "Open Recent" },
            expectedResult = {
                { AXTitle = "test.txt" },
                { AXTitle = "text.txt" },
            },
        },
        {
            name = "returns nil if the path does not exist in the menu items",
            menuItems = { {
                AXTitle = "File",
                AXChildren = { { {
                    AXTitle = "Open Recent",
                    AXChildren = { {
                        { AXTitle = "test.txt" },
                        { AXTitle = "text.txt" },
                    } },
                } } },
            } },
            menuItemPath = { "Invalid", "Invalid Path" },
            expectedResult = nil,
        },
    }

    -- Run `getMenuItemList` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local application = require("application")
            local mockApp = {
                getMenuItems = function()
                    return test.menuItems
                end,
            }
            local result = application.getMenuItemList(mockApp, test.menuItemPath)

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- Entity `initialize` method test suite
local function initializeTests()
    local tests = {
        {
            name = "initializes application instance with name",
            args = { "Application Name" },
            property = "name",
            expected = "Application Name",
        },
        {
            name = "initializes application instance with auto-exit mode value",
            args = { "", _, true },
            property = "autoExitMode",
            expected = true,
        },
    }

    -- Run `initialize` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local application = require("application")

            application.mergeShortcuts = function() end
            application:initialize(table.unpack(test.args))

            assert.are.same(test.expected, application[test.property])
        end)
    end
end

-- Entity `toggleFullScreen` method test suite
local function toggleFullScreenTests()
    local tests = {
        {
            name = "toggles the full screen status of the application's focused window",
            args = {
                {
                    focusedWindow = function()
                        return { toggleFullScreen = function() end }
                    end,
                }
            },
            expectedResult = true,
        },
    }

    -- Run `toggleFullScreen` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local application = require("application")
            local result = application.toggleFullScreen(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- Application `default` behavior function test suite
local function defaultBehaviorTests()
    local behaviorTests = {
        {
            name = "returns assigned auto-exit value if application has name",
            applicationName = "",
            autoExitMode = false,
            args = { spy.new(function() end) },
            eventHandlerCallCount = 0,
            expectedResult = false,
        },
        {
            name = "return custom auto-exit value from event handler",
            applicationName = "Test",
            args = { spy.new(function() return _, false end) },
            eventHandlerCallCount = 1,
            expectedResult = false,
        },
        {
            name = "focuses app if event handler returns true",
            applicationName = "Test",
            args = { spy.new(function() return true end) },
            eventHandlerCallCount = 1,
            focusCallCount = 1,
        },
    }

    -- Run `default` behavior method tests
    for _, test in pairs(behaviorTests) do
        it(test.name, function()
            local eventHandlerSpy = test.args[1]
            local focusSpy = spy.new(function() end)
            local application = require("application")

            application.focus = focusSpy
            application.name = test.applicationName
            application.autoExitMode = test.autoExitMode
            application.getApplication = function()
                return #test.applicationName > 0 and {} or nil
            end

            assert.are.same(type(application.behaviors.default), "function")

            local result = application.behaviors.default(application, table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
            assert.spy(eventHandlerSpy).was.called(test.eventHandlerCallCount)
            if test.focusCallCount and test.focusCallCount > 0 then
                assert.spy(focusSpy).was.called(test.focusCallCount)
            end
        end)
    end
end

-- Application `select` mode behavior function test suite
local function selectBehaviorTests()
    local behaviorTests = {
        {
            name = "returns assigned auto-exit value if application has name",
            applicationName = "",
            autoExitMode = false,
            args = { spy.new(function() end) },
            eventHandlerCallCount = 0,
            expectedResult = false,
        },
        {
            name = "auto-exits if there are no choices",
            applicationName = "Test",
            args = { spy.new(function() end) },
            eventHandlerCallCount = 0,
            expectedResult = true,
        },
        {
            name = "shows selection modal",
            applicationName = "Test",
            args = { spy.new(function() end) },
            selectionItems = { {}, {} },
            eventHandlerCallCount = 0,
            expectedResult = true,
        },
        {
            name = "invokes event handler on selection",
            applicationName = "Test",
            args = { spy.new(function() end) },
            selectionItems = { {}, {} },
            eventHandlerCallCount = 1,
            expectedResult = true,
            choice = {},
        },
    }

    -- Run `select` mode behavior method tests
    for _, test in pairs(behaviorTests) do
        it(test.name, function()
            local eventHandlerSpy = test.args[1]
            local application = require("application")

            application.name = test.applicationName
            application.autoExitMode = test.autoExitMode
            application.getSelectionItems = function()
                return test.selectionItems
            end
            application.getApplication = function()
                return #test.applicationName > 0 and {} or nil
            end
            -- Mock show selection modal callback to immediately trigger an item selection
            application.showSelectionModal = function(_, callback)
                callback(test.choice)
            end

            assert.are.same(type(application.behaviors.select), "function")

            local result = application.behaviors.select(application, table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
            assert.spy(eventHandlerSpy).was.called(test.eventHandlerCallCount)
        end)
    end
end

describe("application.lua (#application)", function()
    local printFunc = _G.print

    -- Set global shortcut indices
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_EVENT_HANDLER_INDEX = 3
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded.application = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker()
        _G.print = function() end
    end)

    after_each(function()
        _G.hs = nil
        _G.requirePackage = nil
        _G.print = printFunc
    end)

    describe("`createMenuItemEvent` method", createMenuItemEventTests)
    describe("`focus` method", focusTests)
    describe("`getApplication` method", getApplicationTests)
    describe("`getMenuItemList` method", getMenuItemListTests)
    describe("`initialize` method", initializeTests)
    describe("`toggleFullScreen` method", toggleFullScreenTests)
    describe("`default` behavior function", defaultBehaviorTests)
    describe("`select` behavior function", selectBehaviorTests)
end)
