local assertions = require("spec.assertions")

assertions:init(require("say"), assert)

describe("util.lua", function()
    it("should expose public functions", function()
        local util = require("util")

        assert.are.equal(type(util.clone), "function")
        assert.are.equal(type(util.areListsEqual), "function")
    end)

    describe("determine lists are equal", function()
        it("should return false for inconsistent types", function()
            local util = require("util")

            assert.are.equal(util.areListsEqual({}, "{}"), false)
        end)

        it("should return false for tables with inconsistent lengths", function()
            local util = require("util")

            assert.are.equal(util.areListsEqual({ 1, 2 }, { 1, 2, 3 }), false)
        end)

        it("should return false for tables with inconsistent values", function()
            local util = require("util")

            assert.are.equal(util.areListsEqual({ 1, 2, 3 }, { 4, 5, 6 }), false)
        end)

        it("should return true for two empty tables", function()
            local util = require("util")

            assert.are.equal(util.areListsEqual({}, {}), true)
        end)

        it("should return true for equal lists", function()
            local util = require("util")

            assert.are.equal(util.areListsEqual({ 1, 2, 3 }, { 1, 2, 3 }), true)
        end)
    end)

    describe("clone values", function()
        it("should clone non-table values", function()
            local util = require("util")
            local inputs = {
                nilValue = nil,
                boolValue = true,
                numberValue = 1234,
                stringValue = "string",
                functionValue = function() end,
            }

            for _, value in pairs(inputs) do
                assert.are.equal(value, util:clone(value))
            end
        end)

        it("should clone tables", function()
            local util = require("util")
            local input = {
                test = true,
                nested = {
                    test = true,
                }
            }

            assert.are.same(input, util:clone(input))
        end)

        it("should clone metatables", function()
            local util = require("util")
            local input = { test = true }
            local metatable = {
                __add = function() end
            }

            setmetatable(input, metatable)

            local clonedMetatable = getmetatable(input)

            assert.are.same(input, util:clone(input))
            assert.are.same(metatable, clonedMetatable)
        end)
    end)
end)
