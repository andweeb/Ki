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

-- File behavior methods test suite
local function behaviorTests()
    local tests = {
        {
            name = "calls event handler with file path and auto-exits mode",
            behavior = "default",
            args = { function() end },
            expectedResult = true,
        },
    }

    -- Run behavior method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local result = file.behaviors[test.behavior](file, table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- File `initialize` method test suite
local function initializeTests()
    local tests = {
        {
            name = "creates a file entity instance",
            args = { "~/.vimrc" },
        },
        {
            name = "creates a file entity instance",
            args = { "~/Downloads" },
            isDirectory = true,
        },
    }

    -- Run `initialize` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local file = require("file")
            local mockFs = {
                attributes = function() return { mode = test.isDirectory and "directory" } end,
                pathToAbsolute = function() end,
            }

            _G.hs = mock(mockHs({ fs = mockFs }))

            file.mergeShortcuts = function() end
            file:initialize(table.unpack(test.args))

            assert.are.same(file.path, test.args[1])
        end)
    end
end

-- File `getFileIcon` method test suite
local function getFileIconTests()
    local tests = {
        {
            name = "gets the file icon",
            args = { "/test/path" },
            expectedResult = "file image",
        },
        {
            name = "returns nil when there is no path",
            args = { nil },
            expectedResult = nil,
        },
    }

    -- Run `getFileIcon` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local mockHs = hammerspoonMocker()
            local mockImage = {
                iconForFileType = function()
                    return test.expectedResult
                end,
            }

            _G.hs = mock(mockHs({ image = mockImage }))

            local result = file.getFileIcon(table.unpack(test.args))

            assert.are.same(test.expectedResult, result)
        end)
    end
end

-- File `navigate` method test suite
local function navigateTests()
    local tests = {
        {
            name = "invokes handler on selection",
            args = {
                "/test/path",
                function(targetPath)
                    assert.are.same("/test/path/selected", targetPath)
                end,
            },
            selections = {
                {
                    attributes = { mode = "file" },
                    args = {
                        "/test/path/selected",
                        false,
                    },
                },
            },
            navigateCallCount = 1,
        },
        {
            name = "invokes selection on a directory if flag is set",
            args = {
                "/test/path",
                function(targetPath)
                    assert.are.same("/test/path/selected", targetPath)
                end,
            },
            selections = {
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/selected",
                        true,
                    },
                },
            },
            navigateCallCount = 1,
        },
        {
            name = "recursively navigates until a file selection is made",
            args = {
                "/test/path",
                function(targetPath)
                    assert.are.same("/test/path/entered/recursively/selected", targetPath)
                end,
            },
            selections = {
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/entered",
                        false,
                    },
                },
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/entered/recursively",
                        false,
                    },
                },
                {
                    attributes = { mode = "file" },
                    args = {
                        "/test/path/entered/recursively/selected",
                        false,
                    },
                },
            },
            navigateCallCount = 3,
        },
        {
            name = "recursively navigates until a selection is made on a directory with flag set",
            args = {
                "/test/path",
                function(targetPath)
                    assert.are.same("/test/path/entered/recursively/selected", targetPath)
                end,
            },
            selections = {
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/entered",
                        false,
                    },
                },
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/entered/recursively",
                        false,
                    },
                },
                {
                    attributes = { mode = "directory" },
                    args = {
                        "/test/path/entered/recursively/selected",
                        true,
                    },
                },
            },
            navigateCallCount = 3,
        },
    }

    -- Run `navigate` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local navigateSpy = spy.on(file, "navigate")
            local mockHs = hammerspoonMocker()
            local mockTimer = {
                doAfter = function(_, callback)
                    callback()
                end,
            }
            local mockFs = {
                pathToAbsolute = function() end,
                attributes = function()
                    -- Mock hs.fs.attributes to mock the type of the selected file
                    local index = #navigateSpy.calls
                    return test.selections[index].attributes
                end,
            }

            -- Mock timer to invoke the callback immediately
            _G.hs = mock(mockHs({ fs = mockFs, timer = mockTimer }))

            -- Mock selection modal to invoke a selection immediately with mocked args
            file.showFileSelectionModal = function(_, _, callback)
                local index = #navigateSpy.calls
                callback(table.unpack(test.selections[index].args))
            end

            file.navigate(file, table.unpack(test.args))

            assert.spy(navigateSpy).was.called(test.navigateCallCount)
        end)
    end
end

-- File `showFileSelectionModal` method test suite
local function showFileSelectionModalTests()
    local tests = {
        {
            name = "notifies on directory iterator error",
            args = { "/test/path" },
            absolutePath = "/absolute/test/path",
            files = {},
            expectedChoices = {},
            notifiesError = "Error walking the path at /test/path"
        },
    }

    -- Run `showFileSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local counter = 0
            local file = require("file")
            local mockHs = hammerspoonMocker()
            local mockFs = {
                pathToAbsolute = function()
                    return test.absolutePath
                end,
                dir = function()
                    counter = counter + 1
                    return test.files[counter]
                end,
            }

            file.notifyError = spy.new(function() end)
            file.mergeShortcuts = function() return {} end
            file.showSelectionModal = function(choices)
                assert.are.same(test.expectedChoices, choices)
            end

            _G.hs = mock(mockHs({ fs = mockFs }))

            file:showFileSelectionModal(table.unpack(test.args))

            if test.notifiesError then
                assert.spy(file.notifyError).was.called_with(test.notifiesError)
            end
        end)
    end
end

-- File `open` method test suite
local function openTests()
    local tests = {
        {
            name = "opens the file",
            args = { "/test/path" },
            openCallCount = 1,
        },
        {
            name = "returns nil when there is no path",
            args = { nil },
            openCallCount = 0,
        },
        {
            name = "opens finder when opening a directory",
            args = { "/test/path" },
            isDirectory = true,
            openCallCount = 1,
            openFinderCount = 1,
        },
    }

    -- Run `open` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local fileOpenSpy = spy.new(function() end)
            local finderOpenSpy = spy.new(function() end)
            local mockHs = hammerspoonMocker()
            local mockFs = {
                attributes = function() return { mode = test.isDirectory and "directory" } end,
                pathToAbsolute = function() end,
            }
            local mockApplication = {
                open = finderOpenSpy,
            }

            _G.hs = mock(mockHs({
                application = mockApplication,
                open = fileOpenSpy,
                fs = mockFs,
            }))

            file.open(table.unpack(test.args))

            assert.spy(fileOpenSpy).was.called(test.openCallCount)
            assert.spy(finderOpenSpy).was.called(test.openFinderCount or 0)
        end)
    end
end

-- File `openWith` method test suite
local function openWithTests()
    local tests = {
        {
            name = "successfully opens the file with application",
            args = { "/test/path" },
            shellOutput = "/Applications/Test.app\n/Applications/Utilities/Test.app\n",
            isSuccessful = true,
            selectedFile = {
                applicationPath = "/Applications/Test.app",
            },
            applescriptReturnValues = {
                true,
            },
        },
        {
            name = "notifies on opening file with application error",
            args = { "/test/path" },
            shellOutput = "/Applications/Test.app\n/Applications/Utilities/Test.app\n",
            isSuccessful = false,
            selectedFile = {
                applicationPath = "/Applications/Test.app",
            },
            applescriptReturnValues = {
                false,
                nil,
                {},
            },
        },
    }

    -- Run `openWith` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local mockHs = hammerspoonMocker()
            local mockFs = {
                pathToAbsolute = function()
                    return test.expectedResult
                end,
            }
            local mockTimer = {
                doAfter = function(_, callback)
                    callback()
                end,
            }

            -- Mock selection modal to invoke a selection immediately with mocked args
            -- and mock notify error to ensure it's called when appropriate
            file.notifyError = spy.new(function() end)
            file.showSelectionModal = function(_, callback)
                callback(test.selectedFile)
            end

            _G.hs = mock(mockHs({
                fs = mockFs,
                timer = mockTimer,
                execute = function() return test.shellOutput end,
                osascript = {
                    applescript = function()
                        return table.unpack(test.applescriptReturnValues)
                    end
                },
            }))

            file.openWith(file, table.unpack(test.args))

            if test.isSuccessful then
                assert.spy(file.notifyError).was.called(0)
            else
                assert.spy(file.notifyError).was.called(1)
            end
        end)
    end
end

-- File `openInfoWindow` method test suite
local function openInfoWindowTests()
    local tests = {
        {
            name = "opens the file info window successfully",
            args = { "/test/path" },
            isSuccessful = true,
            applescriptResults = {
                true,
            },
        },
        {
            name = "notifies on applescript error",
            args = { "/test/path" },
            isSuccessful = false,
            applescriptResults = {
                false,
                nil,
                {},
            },
        },
    }

    -- Run `openInfoWindow` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local mockHs = hammerspoonMocker()
            local mockOsascript = {
                applescript = function()
                    return table.unpack(test.applescriptResults)
                end,
            }

            file.notifyError = spy.new(function() end)

            _G.hs = mock(mockHs({ osascript = mockOsascript }))

            file:openInfoWindow(table.unpack(test.args))

            if test.isSuccessful then
                assert.spy(file.notifyError).was.called(0)
            else
                assert.spy(file.notifyError).was.called(1)
            end
        end)
    end
end

-- File `moveToTrash` method test suite
local function moveToTrashTests()
    local tests = {
        {
            name = "cancel file move operation",
            args = { "/test/path" },
            confirmation = "Cancel",
            executesApplescript = false,
        },
        {
            name = "moves the file to trash successfully",
            args = { "/test/path" },
            confirmation = "Confirm",
            executesApplescript = true,
            applescriptResults = {
                true,
            },
        },
        {
            name = "notifies on applescript error",
            args = { "/test/path" },
            confirmation = "Confirm",
            executesApplescript = true,
            notifiesError = true,
            applescriptResults = {
                false,
                nil,
                {},
            },
        },
    }

    -- Run `moveToTrash` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local file = require("file")
            local mockHs = hammerspoonMocker()
            local applescriptSpy = spy.new(function()
                return table.unpack(test.applescriptResults)
            end)
            local mockOsascript = {
                applescript = applescriptSpy,
            }
            local mockDialog = {
                blockAlert = function() return test.confirmation end,
            }

            file.notifyError = spy.new(function() end)

            _G.hs = mock(mockHs({
                osascript = mockOsascript,
                dialog = mockDialog,
            }))

            file:moveToTrash(table.unpack(test.args))

            assert.spy(applescriptSpy).was.called(test.executesApplescript and 1 or 0)

            if test.notifiesError then
                assert.spy(file.notifyError).was.called(1)
            end
        end)
    end
end

describe("file.lua (#file)", function()
    -- Set globals
    _G.spoonPath = ""
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

    describe("behaviors", behaviorTests)
    describe("`initialize` method", initializeTests)
    describe("`getFileIcon` method", getFileIconTests)
    describe("`navigate` method", navigateTests)
    describe("`showFileSelectionModal` method", showFileSelectionModalTests)
    describe("`open` method", openTests)
    describe("`openWith` method", openWithTests)
    describe("`openInfoWindow` method", openInfoWindowTests)
    describe("`moveToTrash` method", moveToTrashTests)
    -- describe("`showSelectionModal` method", showSelectionModalTests)
end)
