-- Entity actions
local Action = {}
local DefaultActions = {}

-- Add metamethods to allow default actions to be invoked and indexed
setmetatable(Action, {
    __call = function(_, ...)
        return Action.createAction(...)
    end,
    __index = function(_, key)
        return DefaultActions[key]
    end,
})

function Action.createAction(options)
    local newAction = {}
    local name, action, actionOptions

    if #options > 0 then
        name, action = table.unpack(options)
    else
        name = options.name
        action = options.action
        actionOptions = options.options
    end

    -- Add metamethods to allow the newly created action to be invokable and indexable
    setmetatable(newAction, {
        __call = function(_, ...) return action(...) end,
        __tostring = function() return "action" end,
        __index = function(_, key)
            if key == "name" then
                return name
            elseif key == "action" then
                return action
            elseif key == "options" then
                return actionOptions
            end
        end,
    })

    return newAction
end

-- Default action to allow passing through the keydown event to propagate to any other
-- applications watching for that event
function DefaultActions.Passthrough(name)
    local passthroughAction = {}

    -- Add metamethods to allow action to be invokable and indexable
    setmetatable(passthroughAction, {
        __call = function() return nil, false end,
        __tostring = function() return "action" end,
        __index = function(_, key)
            if key == "name" then
                return name
            end
        end,
    })

    return passthroughAction
end

return Action
