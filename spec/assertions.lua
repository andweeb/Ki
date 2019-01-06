local assertions = {}

local function areListsEqual(list1, list2)
    if #list1 ~= #list2 then return false end
    if #list1 == 0 and #list2 == 0 then return true end

    for _, value1 in pairs(list1) do
        local valueExists = false

        for _, value2 in pairs(list2) do
            if value1 == value2 then
                valueExists = true
                break
            end
        end

        if not valueExists then return false end
    end

    return true
end

assertions.has_property = {
    positive = "Expected %s \nto have value: %s",
    negative = "Expected %s \nto not have value: %s",
    assertion = function(_, arguments)
        if not type(arguments[1]) == "table" or #arguments ~= 2 then
            return false
        end

        for key, _ in pairs(arguments[1]) do
            if key == arguments[2] then return true end
        end
    end,
}

assertions.has_value = {
    positive = "Expected %s \nto exist in list: %s",
    negative = "Expected %s \nto not exist in list: %s",
    assertion = function(_, arguments)
        if #arguments ~= 2 or type(arguments[1]) ~= "table" then
            return false
        end

        for _, value in pairs(arguments[1]) do
            if type(value) == "table" and type(arguments[2]) == "table" then
                if areListsEqual(value, arguments[2]) then
                    return true
                end
            elseif value == arguments[2] then
                return true
            end
        end

        return false
    end,
}

assertions.is_greater_than = {
    positive = "Expected %s \nto be greater than %s",
    negative = "Expected %s \nto not be greater than %s",
    assertion = function(_, arguments)
        return arguments[1] > arguments[2]
    end
}

assertions.is_less_than = {
    positive = "Expected %s \nto be less than %s",
    negative = "Expected %s \nto not be less than %s",
    assertion = function(_, arguments)
        return arguments[1] < arguments[2]
    end
}

function assertions:init(say, assert)
    for name, data in pairs(self) do
        if type(data) ~= "function" then
            local positiveKey = "assertion."..name..".positive"
            local negativeKey = "assertion."..name..".negative"

            say:set(positiveKey, data.positive)
            say:set(negativeKey, data.negative)

            assert:register("assertion", name, data.assertion, positiveKey, negativeKey)
        end
    end
end

return assertions
