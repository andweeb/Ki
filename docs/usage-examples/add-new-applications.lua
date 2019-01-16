-- Example `init.lua` file that creates new custom application entities to automate

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Create new Ki applications
local Application = spoon.Ki.Application
local Slack = Application:new("Slack")
local Hammerspoon = Application:new("Hammerspoon")
local MicrosoftExcel = Application:new("Microsoft Excel")

-- Define custom entity workflows
local entityEvents = {
    { nil, "e", MicrosoftExcel, { "Entities", "Microsoft Excel" } },
    { { "shift" }, "h", Hammerspoon, { "Entities", "Hammerspoon" } },
    { { "shift", "cmd" }, "s", Slack, { "Entities", "Slack" } },
}

-- Use relevant application entities that can have multiple windows to be available in select mode
local selectEntityEvents = {
    { nil, "e", MicrosoftExcel, { "Entities", "Microsoft Excel" } },
}

-- Set custom workflows
spoon.Ki.workflowEvents = {
    entity = entityEvents,
    select = selectEntityEvents,
}

-- Start Ki
spoon.Ki:start()
