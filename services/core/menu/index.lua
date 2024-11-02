local view_main = require("@pierrelasse/bamboo/services/core/menu/view/main")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---@type ScriptCommand
    local cmd

    service.onEnable = function()
        if cmd == nil then
            cmd = addCommand("config", function(sender, args)
                sender.sendMessage("menu.open")
                view_main(sender)
            end).permission("op")
        else
            cmd.register()
        end
    end

    service.onDisable = function()
        cmd.unregister()
    end
end
