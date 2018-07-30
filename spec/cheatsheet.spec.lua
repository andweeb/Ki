local assertions = require("spec.assertions")

assertions:init(require("say"), assert)

describe("cheatsheet.lua", function()
    describe("determine lists are equal", function()
        it("should initialize a cheatsheet", function()
            local cheatsheet = require("cheatsheet")

            assert.has_property(cheatsheet, "name")
            assert.has_property(cheatsheet, "description")
            assert.has_property(cheatsheet, "actions")
            assert.has_property(cheatsheet, "view")
        end)
    end)
end)
