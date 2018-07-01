local mockHs = require("spec.mock-hammerspoon")()
local assertions = require("spec.assertions")

assertions:init(require("say"), assert)

describe("status-display.lua", function()
    it("should expose public functions", function()
        local statusDisplay = require("status-display")

        assert.are.equal(type(statusDisplay), "table")
        assert.are.equal(type(statusDisplay.show), "function")
    end)

    describe("show status display", function()
        setup(function()
            _G.hs = mock(mockHs())
        end)

        teardown(function()
            _G.hs = nil
        end)

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

        it("should fade out the normal mode status display", function()
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

            statusDisplay:show("normal")

            assert.spy(mockDisplay.delete).was.called()
            assert.spy(mockDisplay.delete).was.called_with(mockDisplay, fadeTimeout)
            assert.falsy(next(statusDisplay.displays))
        end)
    end)
end)
