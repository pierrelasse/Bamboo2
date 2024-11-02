---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---@type ScriptCommand
    local cmd

    service.onEnable = function()
        if cmd == nil then
            cmd =
                addCommand({ "msg", "w", "tell", "minecraft:msg", "minecraft:w", "minecraft:tell" },
                    function(sender, args)
                        if args[1] == nil then
                            sender.sendMessage("§cUsage: /msg <spieler> <nachricht...>")
                            return
                        end

                        local target = bukkit.getPlayer(args[1])
                        if target == nil or not sender.canSee(target) or sender == target then
                            sender.sendMessage("§cSpieler nicht gefunden")
                            return
                        end

                        local message = table.concat(args, " ", 2)
                        sender.sendMessage("§dZu "..target.getName()..":§r "..message)
                        target.sendMessage("§dVon "..sender.getName()..":§r "..message)
                    end)
                .complete(function(completions, sender, args)
                    if #args == 1 then
                        for player in bukkit.onlinePlayersLoop() do
                            local name = player.getName()
                            if string.startswith(name, args[1]) and sender.canSee(player) then
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
