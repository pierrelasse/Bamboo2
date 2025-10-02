---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---@type ScriptCommand
    local cmd

    service.onEnable = function()
        if cmd == nil then
            cmd =
                addCommand({ "msg", "w", "tell" }, function(sender, args)
                    if args[1] == nil then
                        sender.sendMessage("§cUsage: /msg <spieler> <nachricht...>")
                        return
                    end

                    local target = bukkit.getPlayer(args[1])
                    if target == nil or not sender.canSee(target) or sender == target then
                        bukkit.send(sender, Bamboo.translate(
                            Bamboo.getLocale(sender), "services.core/messaging.not_found"))
                        return
                    end

                    local message = table.concat(args, " ", 2)
                    bukkit.send(sender, Bamboo.translateF(
                        Bamboo.getLocale(sender), "services.core/messaging.to", target.getName(), message))
                    bukkit.send(target, Bamboo.translateF(
                        Bamboo.getLocale(target), "services.core/messaging.from", sender.getName(), message))
                end)
                .complete(function(completions, sender, args)
                    if #args == 1 then
                        for player in bukkit.playersLoop() do
                            local name = player.getName()
                            if string.startsWith(name, args[1]) and sender.canSee(player) then
                                completions.add(name)
                            end
                        end
                    end
                end)
        else
            cmd.register()
        end
    end

    service.onDisable = function()
        cmd.unregister()
    end
end
