----------------------------------------------------------------------------------------------------
-- {{entityName}} entity config
--
local Entity = spoon.Ki.Entity
local {{instanceName}} = Entity:new("{{entityName}}")

function {{instanceName}}.defaultAction()
    print("Fired default action for "..{{instanceName}}.name.."!")
end

function {{instanceName}}.mappedAction()
    print("Fired action A for "..{{instanceName}}.name.."!")
end

{{instanceName}}:registerShortcuts({
    { nil, nil, {{instanceName}}.defaultAction, { "{{entityName}}", "Default Action Description" } },
    { nil, "a", {{instanceName}}.mappedAction, { "{{entityName}}", "Mapped Action Description" } },
})

return {{instanceName}}
