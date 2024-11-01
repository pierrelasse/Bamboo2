local view_main = require("@pierrelasse/bamboo/services/core/menu/view/main")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    local command = addCommand("config", function(sender, args)
        sender.sendMessage("menu.open")
        view_main(sender)
    end).permission("op")

    service.onEnable = function()
        command.register()
    end

    service.onDisable = function()
        command.unregister()
    end
end
