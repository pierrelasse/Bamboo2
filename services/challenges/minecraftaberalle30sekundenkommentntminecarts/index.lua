local Bukkit = classFor("org.bukkit.Bukkit")
local ExplosiveMinecart = classFor("org.bukkit.entity.minecart.ExplosiveMinecart")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "Minecraft Aber Alle 30 Sekunden Kommen TNT Minecarts"
    service.meta_material = "TNT_MINECART"

    ---@type ScriptTask
    local task
    local time = 0
    local INTERVAL = 10 --30

    service.onEnable = function()
        task = every(20, function()
            if not Bamboo.timer.isRunning() then return end
            time = time + 1

            if time == INTERVAL - 2 then
                for player in bukkit.onlinePlayersLoop() do
                    bukkit.sendTitle(player, "§cT§4N§cT§4!", nil)
                end
                return
            end

            if time >= INTERVAL then
                time = 0

                for player in bukkit.onlinePlayersLoop() do
                    if player.getGameMode().name() == "SURVIVAL" then
                        local loc = player.getLocation().clone().add(0, math.random(-1, 4), 0)
                        local world = loc.getWorld()
                        local amount = 5
                        -- math.random(1,
                        --                            math.random(0, 1) == 0 and math.random(1, 3) or
                        --                            math.random(1, 10) + math.random(0, 40))
                        bukkit.sendTitle(player, nil, "§c"..amount)
                        for _ = 1, amount do
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
