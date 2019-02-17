local say = require("say")
local assertions = require("spec.assertions")
local hammerspoonMocker = require("spec.mock-hammerspoon")

assertions:init(say, assert)

-- Generate `requirePackage` function to mock external dependencies
local function requirePackageMocker(mocks)
    mocks = mocks or {}

    local defaultMocks = {
        lustache = mocks.lustache or mock({
            render = function() end
        }),
        middleclass = mocks.middleclass or mock(function()
            return {
                subclass = function()
                    return {}
                end
            }
        end),
    }

    for key, value in pairs(mocks) do
        defaultMocks[key] = value
    end

    mocks = defaultMocks

    return function(name, isInternal)
        if isInternal then
            return mocks[name] or mock(dofile("src/"..name..".lua"))
        else
            return mocks[name]
        end
    end
end

-- SmartFolder `initialize` method test suite
local function initializeTests()
    local tests = {
        {
            name = "creates a smart folder entity instance",
            args = { "~/.savedSearch" },
        },
    }

    -- Run `initialize` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local SmartFolder = require("smart-folder")
            local mockFs = {
                pathToAbsolute = function() return test.args[1] end,
            }

            _G.hs = mock(mockHs({ fs = mockFs }))

            SmartFolder.mergeShortcuts = function() end
            SmartFolder:initialize(table.unpack(test.args))

            assert.are.same(SmartFolder.path, test.args[1])
        end)
    end
end

-- SmartFolder `showFileSearchSelectionModal` method test suite
local function showFileSearchSelectionModalTests()
    local tests = {
        {
            name = "creates a smart folder entity instance",
            args = { "~/.savedSearch" },
            shellOutput  = "/test/path1\n/test/path2\n",
            expectedChoices = {},
        },
    }

    -- Run `showFileSearchSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local SmartFolder = require("smart-folder")
            local mockFs = {
                pathToAbsolute = function() return test.args[1] end,
            }

            _G.hs = mock(mockHs({
                fs = mockFs,
                execute = function()
                    return test.shellOutput
                end,
            }))

            SmartFolder.createFileChoices = function()
                return test.expectedChoices
            end
            SmartFolder.showSelectionModal = function(choices)
                assert.are.same(choices, test.expectedChoices)
            end

            SmartFolder:showFileSearchSelectionModal(table.unpack(test.args))
        end)
    end
end

-- SmartFolder `openFile` method test suite
local function openFileTests()
    local tests = {
        {
            name = "does not open file without a selection",
            args = { "~/.savedSearch" },
            choice = nil,
            opensFile = false,
        },
        {
            name = "opens file with a path selection",
            args = { "~/.savedSearch" },
            choice = "/test/path",
            opensFile = true,
        },
    }

    -- Run `showFileSearchSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local SmartFolder = require("smart-folder")

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice)
            end

            SmartFolder:openFile(table.unpack(test.args))
        end)
    end
end

-- SmartFolder `copy` method test suite
local function copyTests()
    local tests = {
        {
            name = "copies from a source file to a destination folder",
            args = { "~/.savedSearch" },
            choice1 = "/test/source.txt",
            choice2 = "/test/destination",
            navigates = true,
        },
        {
            name = "cancels copying if no selection is made",
            args = { "~/.savedSearch" },
            navigates = false,
        },
    }

    -- Run `copy` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local SmartFolder = require("smart-folder")
            local mockFs = {
                pathToAbsolute = function() return test.args[1] end,
            }

            _G.hs = mock(mockHs({ fs = mockFs }))

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice1 and { path = test.choice1 } or nil)
            end
            SmartFolder.navigate = spy.new(function(_, _, callback)
                return callback(test.choice2)
            end)
            SmartFolder.triggerAfterConfirmation = function(_, callback)
                return callback()
            end
            SmartFolder.runFileModeApplescript = function(_, viewModel)
                assert.are.same(viewModel.filePath1, test.choice1)
                assert.are.same(viewModel.filePath2, test.choice2)
            end

            SmartFolder:copy(table.unpack(test.args))

            assert.spy(SmartFolder.navigate).was.called(test.navigates and 1 or 0)
        end)
    end
end

-- SmartFolder `moveToTrash` method test suite
local function moveToTrashTests()
    local tests = {
        {
            name = "does not open file without a selection",
            args = { "~/.savedSearch" },
            choice = nil,
            movesToTrash = false,
        },
        {
            name = "opens file with a path selection",
            args = { "~/.savedSearch" },
            choice = "/test/path",
            movesToTrash = true,
        },
    }

    -- Run `showFileSearchSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local moveToTrashSpy = spy.new(function() end);

            _G.requirePackage = requirePackageMocker({
                File = mock({
                    subclass = function() return {} end,
                    moveToTrash = moveToTrashSpy,
                }),
            })

            local SmartFolder = require("smart-folder")

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice)
            end

            SmartFolder:moveToTrash(table.unpack(test.args))

            assert.spy(moveToTrashSpy).was.called(test.movesToTrash and 1 or 0)
        end)
    end
end

-- SmartFolder `move` method test suite
local function moveTests()
    local tests = {
        {
            name = "moves a selected source file to a destination folder",
            args = { "~/.savedSearch" },
            choice1 = "/test/source.txt",
            choice2 = "/test/destination",
            navigates = true,
        },
        {
            name = "cancels moving if no selection is made",
            args = { "~/.savedSearch" },
            navigates = false,
        },
    }

    -- Run `move` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local SmartFolder = require("smart-folder")
            local mockFs = {
                pathToAbsolute = function() return test.args[1] end,
            }

            _G.hs = mock(mockHs({ fs = mockFs }))

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice1 and { path = test.choice1 } or nil)
            end
            SmartFolder.navigate = spy.new(function(_, _, callback)
                return callback(test.choice2)
            end)
            SmartFolder.triggerAfterConfirmation = function(_, callback)
                return callback()
            end
            SmartFolder.runFileModeApplescript = function(_, viewModel)
                assert.are.same(viewModel.filePath1, test.choice1)
                assert.are.same(viewModel.filePath2, test.choice2)
            end

            SmartFolder:move(table.unpack(test.args))

            assert.spy(SmartFolder.navigate).was.called(test.navigates and 1 or 0)
        end)
    end
end

-- SmartFolder `openFileWith` method test suite
local function openFileWithTests()
    local tests = {
        {
            name = "does not open file without a selection",
            args = { "~/.savedSearch" },
            choice = nil,
            movesToTrash = false,
        },
        {
            name = "opens file with a path selection",
            args = { "~/.savedSearch" },
            choice = "/test/path",
            movesToTrash = true,
        },
    }

    -- Run `showFileSearchSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local openFileWithSpy = spy.new(function() end);

            _G.requirePackage = requirePackageMocker({
                File = mock({
                    subclass = function() return {} end,
                    openWith = openFileWithSpy,
                }),
            })

            local SmartFolder = require("smart-folder")

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice)
            end

            SmartFolder:openFileWith(table.unpack(test.args))

            assert.spy(openFileWithSpy).was.called(test.movesToTrash and 1 or 0)
        end)
    end
end

-- SmartFolder `openInfoWindow` method test suite
local function openInfoWindowTests()
    local tests = {
        {
            name = "does not open file without a selection",
            args = { "~/.savedSearch" },
            choice = nil,
            movesToTrash = false,
        },
        {
            name = "opens file with a path selection",
            args = { "~/.savedSearch" },
            choice = "/test/path",
            movesToTrash = true,
        },
    }

    -- Run `showFileSearchSelectionModal` method tests
    for _, test in pairs(tests) do
        it(test.name, function()
            local openInfoWindowSpy = spy.new(function() end);

            _G.requirePackage = requirePackageMocker({
                File = mock({
                    subclass = function() return {} end,
                    openInfoWindow = openInfoWindowSpy,
                }),
            })

            local SmartFolder = require("smart-folder")

            SmartFolder.showFileSearchSelectionModal = function(_, _, callback)
                return callback(test.choice)
            end

            SmartFolder:openInfoWindow(table.unpack(test.args))

            assert.spy(openInfoWindowSpy).was.called(test.movesToTrash and 1 or 0)
        end)
    end
end

describe("smart-folder.lua (#smartfolder)", function()
    -- Set globals
    _G.spoonPath = ""
    _G.SHORTCUT_MODKEY_INDEX = 1
    _G.SHORTCUT_HOTKEY_INDEX = 2
    _G.SHORTCUT_EVENT_HANDLER_INDEX = 3
    _G.SHORTCUT_METADATA_INDEX = 4

    before_each(function()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded["smart-folder"] = nil
        _G.hs = mock(hammerspoonMocker()())
        _G.requirePackage = requirePackageMocker({
            File = mock({ subclass = function() return {} end }),
        })
    end)

    after_each(function()
        _G.hs = nil
        _G.requirePackage = nil
    end)

    describe("`initialize` method", initializeTests)
    describe("`showFileSearchSelectionModal` method", showFileSearchSelectionModalTests)
    describe("`openFile` method", openFileTests)
    describe("`copy` method", copyTests)
    describe("`moveToTrash` method", moveToTrashTests)
    describe("`move` method", moveTests)
    describe("`openFileWith` method", openFileWithTests)
    describe("`openInfoWindow` method", openInfoWindowTests)
end)
