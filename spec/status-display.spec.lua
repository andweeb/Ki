local say = require("say")
local assertions = require("spec.assertions")
local hammerspoonMocker = require("spec.mock-hammerspoon")

assertions:init(say, assert)

-- Status display `createTextElement` method test suite
local function createTextElementTests()
    local tests = {
        {
            name = "creates text element in default mode",
            args = { "text" },
            inDarkMode = false,
            expectedTextColor = { red = 0, blue = 0, green = 0 },
        },
        {
            name = "creates text element in dark mode",
            args = { "text" },
            inDarkMode = true,
            expectedTextColor = { red = 0.8, blue = 0.8, green = 0.8 },
        },
    }

    -- Run `createTextElement` method test cases
    for _, test in pairs(tests) do
        it(test.name, function()
            local mockHs = hammerspoonMocker()
            local newTextStyleSpy = spy.new(function() end)
            local mockStyledText = { new = newTextStyleSpy }
            local mockOsascript = {
                applescript = function()
                    return _, test.inDarkMode
                end
            }

            _G.hs = mock(mockHs({
                osascript = mockOsascript,
                styledtext = mockStyledText,
            }))

            local statusDisplay = require("status-display")
            statusDisplay:createTextElement(table.unpack(test.args))

            assert.spy(newTextStyleSpy).called_with(test.args[1], {
                color = test.expectedTextColor,
                font = { name = "Menlo", size = 10 },
                paragraphStyle = { alignment = "center" },
            })
        end)
    end
end

describe("status-display.lua (#statusdisplay)", function()
    before_each(function()
        -- Setup each test with a fake Hammerspoon environment and mocked external dependencies
        package.loaded["status-display"] = nil
        _G.hs = mock(hammerspoonMocker()())
    end)

    after_each(function()
        _G.hs = nil
        _G.requirePackage = nil
    end)

    describe("`createTextElement` method", function() createTextElementTests() end)

    describe("`show` method", function()
        it("should clear pre-existing canvases", function()
            local statusDisplay = require("status-display")
            local mockDisplay = { delete = function() end }

            -- Test for an initially empty `displays` table
            assert.are.equal(type(statusDisplay.displays), "table")
            assert.falsy(next(statusDisplay.displays))

            statusDisplay.displays = { shouldBeCleared = mockDisplay }
            statusDisplay:show("test")

            assert.is_not.has_property(statusDisplay, "shouldBeCleared")
        end)

        it("should render displays", function()
            local mockHs = hammerspoonMocker()
            local statusDisplay = require("status-display")
            local mockDisplay = { delete = function() end }
            local testStatus = "test"

            _G.hs = mock(mockHs({
                canvas = {
                    new = function()
                        return {
                            appendElements = function()
                                return {
                                    show = function()
                                        return mockDisplay
                                    end
                                }
                            end
                        }
                    end
                }
            }))

            statusDisplay:show(testStatus)

            assert.are.equal(type(statusDisplay.displays), "table")
            assert.has_property(statusDisplay.displays, testStatus)
        end)

        it("should render display with status and action text", function()
            local statusDisplay = require('status-display')
            local testStatus = "test"
            local testAction = "test-action"

            statusDisplay.createTextElement = spy.new(function() end)
            statusDisplay:show(testStatus, testAction)

            assert.spy(statusDisplay.createTextElement).was.called()
            assert.are.equal(type(statusDisplay.displays), "table")
        end)

        it("should fade out the desktop mode status display", function()
            local mockHs = hammerspoonMocker()
            local statusDisplay = require('status-display')
            local mockDisplay = { delete = spy.new(function() end) }
            local fadeTimeout = statusDisplay.DEFAULT_FADE_TIMEOUT

            _G.hs = mock(mockHs({
                canvas = {
                    new = function()
                        return {
                            appendElements = function()
                                return {
                                    show = function()
                                        return mockDisplay
                                    end
                                }
                            end
                        }
                    end
                }
            }))

            statusDisplay:show("desktop")

            assert.spy(mockDisplay.delete).was.called()
            assert.spy(mockDisplay.delete).was.called_with(mockDisplay, fadeTimeout)
            assert.falsy(next(statusDisplay.displays))
        end)
    end)
end)
