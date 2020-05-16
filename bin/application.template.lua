----------------------------------------------------------------------------------------------------
-- {{{entityName}}} application
--
local Application = spoon.Ki.Application
local {{{instanceName}}} = Application:new("{{{entityName}}}")

-- Initialize menu item events
{{{actionInitializations}}}

{{{instanceName}}}:registerShortcuts({
{{{shortcuts}}}
})

return {{{instanceName}}}
