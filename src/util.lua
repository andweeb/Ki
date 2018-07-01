local util = {}

function util.areListsEqual(list1, list2)
    if type(list1) ~= "table" or type(list2) ~= "table" or #list1 ~= #list2 then
        return false
    end
    if #list1 == 0 and #list2 == 0 then
        return true
    end

    for _, value1 in pairs(list1) do
        local valueExists = false

        for _, value2 in pairs(list2) do
            if value1 == value2 then
                valueExists = true
                break
            end
        end

        if not valueExists then
            return false
        end
    end

    return true
end

function util:clone(input)
    local copy

    if type(input) ~= "table" then
        return input
    end

    copy = {}

    for key, value in next, input, nil do
        copy[self:clone(key)] = self:clone(value)
    end

    setmetatable(copy, self:clone(getmetatable(input)))

    return copy
end

return util
