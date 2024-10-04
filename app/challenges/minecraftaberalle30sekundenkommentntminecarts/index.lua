local Bukkit = classFor("org.bukkit.Bukkit")
local ExplosiveMinecart = classFor("org.bukkit.entity.minecart.ExplosiveMinecart")


---@param challenge app.challenge.Challenge
return function(challenge)
    challenge.meta_name = "Minecraft Aber Alle 30 Sekunden Kommen TNT Minecarts"
    challenge.meta_material = "TNT_MINECART"

    ---@type ScriptTask
    local task
    local time = 0

    challenge.onEnable = function()
        task = every(20, function()
            if not Timer.isRunning() then return end
            time = time + 1

            if time >= 60 then
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

    challenge.onDisable = function()
        task.cancel()
        time = 0
    end

    challenge:addTask("test", function(sender, args)
        sender.sendMessage("testt!!")
    end)
end
