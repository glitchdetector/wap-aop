-- Page details
local PAGE_NAME = "aop"
local PAGE_TITLE = "Area of Patrol"
local PAGE_ICON = "map-marker-alt"

-- Sidebar badge
local PAGE_BADGE = false
local PAGE_BADGE_TYPE = "danger"

local CURRENT_AOP = "None Set"
AddEventHandler("AOP:SendAOP", function(area)
    -- Change of AOP indicator
    if area ~= CURRENT_AOP then
        if GetConvar("wap_aop_change_badge", "true") == "true" then PAGE_BADGE = "!" end
        CURRENT_AOP = area
    end
end)
-- Testing command
RegisterCommand("aop", function(source, args, raw)
    TriggerEvent("AOP:SendAOP", table.concat(args, " "))
end, false)

-- Input group builder
local function GenerateInputGroup(FAQ, input, left, right)
    return FAQ.Node("div", {class = "input-group mb-3"}, {
        left and FAQ.Node("div", {class = "input-group-prepend"}, left) or "",
        input,
        right and FAQ.Node("div", {class = "input-group-append"}, right) or "",
    })
end

function CreatePage(FAQ, data, add)
    if data.aop then
        ExecuteCommand("aop " .. data.aop)
        return false, "The <strong>Area of Patrol</strong> was changed to <strong>" .. data.aop .. "</strong>"
    end
    return false, "<strong>glitchdetector</strong> was here"
end

-- Automatically sets up a page and sidebar option based on the above configurations
Citizen.CreateThread(function()
    local PAGE_ACTIVE = false
    local FAQ = exports['webadmin-lua']:getFactory()
    exports['webadmin']:registerPluginPage(PAGE_NAME, function(data) --[[E]]--
        if not exports['webadmin']:isInRole("faxes.aopcmds") then return "" end
        return FAQ.Nodes({ --[[R]]--
            FAQ.PageTitle(PAGE_TITLE),
            FAQ.BuildPage(CreatePage, data), --[[R]]--
        })
    end)
    exports['webadmin']:registerPluginOutlet("home/dashboardTop", function(data)
        local output = {}
        if GetConvar("wap_aop_front", "true") == "true" then
            local alert = FAQ.Alert("info", FAQ.Nodes({"The current Area of Patrol is ", FAQ.Node("strong", {}, CURRENT_AOP)}))
            table.insert(output, alert)
        end
        if not exports['webadmin']:isInRole("faxes.aopcmds") then return FAQ.Nodes(output) end
        local form = FAQ.Form(PAGE_NAME, {}, GenerateInputGroup(FAQ, FAQ.Node("input", {
            type = "text",
            class = "form-control",
            name = "aop",
            value = CURRENT_AOP,
            placeholder = "Los Santos",
        }, ""), FAQ.Node("span", {class = "input-group-text"}, "Current Area of Patrol"), FAQ.Button("primary", {
            "Change Area of Patrol ", FAQ.Icon("sync-alt")
        }, {type = "submit"})))
        table.insert(output, form)
        return FAQ.Nodes(output)
    end)
    exports['webadmin']:registerPluginOutlet("nav/topList", function(data)
        if GetConvar("wap_aop_top", "true") ~= "true" then return "" end
        local badge = FAQ.Badge("info", {"AOP: ", CURRENT_AOP})
        return badge
    end)
end)
