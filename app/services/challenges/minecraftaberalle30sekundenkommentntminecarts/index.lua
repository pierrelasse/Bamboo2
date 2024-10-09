local Bukkit = classFor("org.bukkit.Bukkit")
local ExplosiveMinecart = classFor("org.bukkit.entity.minecart.ExplosiveMinecart")


---@param service app.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "Minecraft Aber Alle 30 Sekunden Kommen TNT Minecarts"
    service.meta_material = "TNT_MINECART"

    ---@type ScriptTask
    local task
    local time = 0
    local INTERVAL = 30

    service.onEnable = function()
        task = every(20, function()
            if not Timer.isRunning() then return end
            time = time + 1

            if time >= INTERVAL then
                time = 0

                for player in forEach(Bukkit.getOnlinePlayers()) do
                    if player.getGameMode().name() == "SURVIVAL" then
                        local loc = player.getLocation()
                        local world = loc.getWorld()
                        for _ = 1, 30 do
                            world.spawn(loc, ExplosiveMinecart)
                        end
                    end
                end
            end
        end)
    end

    service.onDisable = function()
        task.cancel()
        time = 0
    end

    service.onReset = function()
        time = 0
    end

    service:addTask("get_time", function(sender)
        sender.sendMessage("§7Time: §e"..time.."/"..INTERVAL)
    end)

    service:addTask("now", function(sender)
        time = INTERVAL
    end)
end
