local HeightMap = import("org.bukkit.HeightMap")
local BlockBreakEvent = import("org.bukkit.event.block.BlockBreakEvent")
local EntityDeathEvent = import("org.bukkit.event.entity.EntityDeathEvent")
local LivingEntity = import("org.bukkit.entity.LivingEntity")

local Storage = require("@pierrelasse/bamboo/util/Storage")
local menu_waves = require("@pierrelasse/bamboo/services/challenges/mobarmeerandomizer/menu/waves")

---@class pierrelasse.bamboo.services.challenges.mobarmeerandomizer.Props
---@field available table<string, integer>
---@field placed table<integer, table<string, integer>>

---@param service pierrelasse.bamboo.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "Mob Armee Randomizer"
    service.meta_material = "ZOMBIE_SPAWN_EGG"

    local storage = Storage.new(service.id)

    local blockdrops = require("@pierrelasse/bamboo/services/challenges/mobarmeerandomizer/blockdrops")
    service:event(BlockBreakEvent, blockdrops.onBlockBreak)

    ---@type table<string, java.List<java.Object>>
    local mobs = {}

    local function spreadPlayers()
        local world = bukkit.world("gameworld")
        if world == nil then return end
        local x = 0
        local z = 100000
        for p in bukkit.playersLoop() do
            if tostring(p.getGameMode()) == "SURVIVAL" then
                x = x + 1000000
                local y = world.getHighestBlockYAt(x, z, HeightMap.WORLD_SURFACE)
                p.teleport(bukkit.location6(
                    world,
                    x, y, z,
                    0, 0
                ))
            end
        end
    end

    local function startWave(player, id)
        local playerId = bukkit.uuid(player)

        local playerMobs = mobs[playerId]
        if playerMobs ~= nil then
            for mob in forEach(playerMobs) do
                mob.remove()
            end
        end
        playerMobs = makeList()
        mobs[playerId] = playerMobs

        bukkit.sendTitle(player, "§6Wave "..id, "§6beginnt")

        storage:set("battle."..playerId..".wave", id)

        print("§a"..player.getName().."=============")
        for p in bukkit.playersLoop() do
            if p == player then goto continue end

            print("§6  "..p.getName()..":")

            local key = "placed."..bukkit.uuid(p).."."..id
            for entityType in storage:loopKeys(key) do
                local amount = storage:get(key.."."..entityType)

                print("§d      "..entityType..": "..amount)

                -- local ent = bukkit.spawn(
                --     bukkit.location6(
                --         bukkit.world("gameworld"), -- FIXME
                --         999638, 112, 100130,
                --         0, 0
                --     ),
                --     entityType,
                --     true
                -- )
                -- ent.addScoreboardTag("temp")
                -- playerMobs.add(ent)
            end

            ::continue::
        end
    end

    local function finishConfig()
        for p in bukkit.playersLoop() do
            p.closeInventory()
            p.teleport(bukkit.location6( -- FIXME
                bukkit.world("gameworld"),
                999552, 126, 100190,
                0, 0
            ))
            startWave(p, 1)
        end
    end

    service:event(EntityDeathEvent, function(event)
        local victim = event.getEntity()
        if not instanceof(victim, LivingEntity) then return end
        local killer = victim.getKiller()
        if not bukkit.isPlayer(killer) then return end
        if storage:get("stage") == 1 then
            local key = "available."..bukkit.uuid(killer).."."..tostring(victim.getType())
            storage:set(key, storage:get(key, 0) + 1)
        end
    end)

    ---@type ScriptTask?
    local task

    service.onEnable = function()
        if blockdrops.storage == nil then
            blockdrops.storage = storage
            blockdrops.init()
        end
    end

    service.onTimer = function(state)
        if not state then
            if task ~= nil then
                task.cancel()
                task = nil
            end
            return
        end

        do
            local stage = storage:get("stage")
            if stage == nil then
                storage:set("stage", 1)
                wait(1, spreadPlayers)
            end
        end

        task = every(20, function()
            local stage = storage:get("stage")
            if stage == 1 then
                local timeLeft = storage:get("timeLeft", 90 * 60 + 1)
                timeLeft = timeLeft - 1
                storage:set("timeLeft", timeLeft)

                if timeLeft == 0 then
                    storage:set("timeLeft", nil)
                    storage:set("stage", 2)
                end
            elseif stage == 2 then
            end
        end)
    end

    service.onReset = function()
        storage:set("stage", nil)
        storage:set("timeLeft", nil)
        storage:set("blockdrops", nil)
        storage:set("available", nil)
        storage:set("placed", nil)
    end

    service:task("tpplayers", function(sender, args)
        bukkit.send(sender, "§7Spreading players")
        spreadPlayers()
    end)

    service:task("testui", function(sender, args)
        bukkit.send(sender, "§7Opening menu")
        menu_waves(sender, storage)
    end)

    service:task("info", function(sender, args)
        bukkit.send(sender, "§7Stage: §e"..storage:get("stage", "§70"))
        bukkit.send(sender, "§7Time left: §e"..storage:get("timeLeft", "§70").."s")
    end)

    service:task("finishtimer", function(sender, args)
        storage:set("timeLeft", 1)
        bukkit.send(sender, "§7Set time left to §e1")
    end)

    service:task("finishconfig", function(sender, args)
        bukkit.send(sender, "§7Ending configuration phase")
        finishConfig()
    end)
end
