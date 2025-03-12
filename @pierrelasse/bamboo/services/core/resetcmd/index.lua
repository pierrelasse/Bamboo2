---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---@type ScriptCommand
    local cmd

    service.onEnable = function()
        if cmd == nil then
            cmd = addCommand("reset", function(sender, args)
                if args[1] == "confirm" then
                    bukkit.send(sender, Bamboo.translate(
                        Bamboo.getLocale(sender), "services.core/resetcmd.success"))
                    FastReset(sender)
                else
                    bukkit.send(sender, Bamboo.translate(
                        Bamboo.getLocale(sender), "services.core/resetcmd.fail"))
                end
            end).complete(function(completions, sender, args)
                completions.add("confirm")
            end).permission("op")
        else
            cmd.register()
        end
    end

    service.onDisable = function()
        cmd.unregister()
    end
end
