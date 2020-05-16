----------------------------------------------------------------------------------------------------
-- {{entityName}} URL entity
--
local URL = spoon.Ki.URL
local baseURL = "{{{url}}}"
local {{entityName}} = URL:new(baseURL)

{{entityName}}.paths = {
    { name = "{{entityName}} Main Page", path = baseURL },
    { name = "{{entityName}} Child Page", path = "/page" },
    { name = "{{entityName}} About Page", path = baseURL.."/about" },
}

return {{entityName}}
