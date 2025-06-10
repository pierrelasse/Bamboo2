local Location = import("org.bukkit.Location")
local GameMode = import("org.bukkit.GameMode")
local PlayerPortalEvent = import("org.bukkit.event.player.PlayerPortalEvent")
local PlayerRespawnEvent = import("org.bukkit.event.player.PlayerRespawnEvent")
local PlayerMoveEvent = import("org.bukkit.event.player.PlayerMoveEvent")
local PlayerJoinEvent = import("org.bukkit.event.player.PlayerJoinEvent")

local fs = require("@base/fs")
local worldmanager = require("@bukkit/worldmanager/worldmanager")


local resetting = false
local mainWorld = bukkit.defaultWorld()

local GAME_WORLD_ID = "gameworld"
local gameWorld = worldmanager.get(GAME_WORLD_ID)
if gameWorld == nil then
    Bamboo.debug("loading game world")
    local creator = worldmanager.create(GAME_WORLD_ID)
    if Bamboo.serviceManager.worldGenOverworld ~= nil then
        creator:setGenerator(Bamboo.serviceManager.worldGenOverworld)
    end
    gameWorld = creator:create()
end
local awaitLocation = Location(mainWorld, 0, -10000, 0, 0, 90)


addEvent(PlayerPortalEvent, function(event)
    local to = event.getTo()
    if to.getWorld() == mainWorld then
        to.setWorld(gameWorld)
        event.setTo(to)
    end
end)

addEvent(PlayerRespawnEvent, function(event)
    if event.getRespawnLocation().getWorld() == mainWorld then
        event.setRespawnLocation(gameWorld.getSpawnLocation().clone().add(.5, 0, .5))
    end
end)

addEvent(PlayerJoinEvent, function(event)
    local player = event.getPlayer()
    if resetting then
        player.kickPlayer("")
        return
    end

    if not player.hasPlayedBefore() then
        local loc = gameWorld.getSpawnLocation().clone().add(.5, 0, .5)
        player.setRespawnLocation(loc)
        player.teleport(loc)
        player.resetTitle()
    end
end)


function FastReset(sender)
    if resetting or not sender.isOnline() then return end
    resetting = true

    Bamboo.timer.reset()

    for player in bukkit.playersLoop() do
        bukkit.sendActionBar(player, Bamboo.translateF(Bamboo.getLocale(player), "reset.by", sender.getName()))
    end

    for player in bukkit.playersLoop() do
        player.teleport(awaitLocation)
        player.setGameMode(GameMode.SPECTATOR)
    end

    local function doTitle(value, max)
        local progress = "§a"
        for _ = 1, value do
            progress = progress.."-"
        end
        progress = progress.."§7"
        for _ = value + 1, max do
            progress = progress.."-"
        end

        for player in bukkit.playersLoop() do
            player.sendTitle(progress, Bamboo.translate(Bamboo.getLocale(player), "reset.deleting"), 0, 999999, 0)
        end
    end
    doTitle(0, 6)


    local moveEvent = addEvent(PlayerMoveEvent, function(event)
        event.setTo(awaitLocation)
    end)

    do
        worldmanager.delete(GAME_WORLD_ID)
        doTitle(1, 6)
        local creator = worldmanager.create(GAME_WORLD_ID)
        gameWorld = creator:create()
    end
    doTitle(2, 6)
    do
        worldmanager.delete("world_nether")
        doTitle(3, 6)
        local creator = worldmanager.create("world_nether")
        creator:setEnvironment(-1)
        if Bamboo.serviceManager.worldGenNether ~= nil then
            creator:setGenerator(Bamboo.serviceManager.worldGenNether)
        end
        creator:create()
    end
    doTitle(4, 6)
    do
        worldmanager.delete("world_the_end")
        doTitle(5, 6)
        local creator = worldmanager.create("world_the_end")
        creator:setEnvironment(1)
        if Bamboo.serviceManager.worldGenEnd ~= nil then
            creator:setGenerator(Bamboo.serviceManager.worldGenEnd)
        end
        creator:create()
    end
    doTitle(6, 6)

    for player in bukkit.playersLoop() do
        player.kickPlayer(Bamboo.translate(Bamboo.getLocale(player), "reset.finish"))
    end


    local mainWorldFolder = mainWorld.getWorldFolder()
    fs.remove(fs.file(mainWorldFolder, "advancements"), true)
    local playerDataFolder = fs.file(mainWorldFolder, "playerdata")
    fs.remove(playerDataFolder, true)
    playerDataFolder.mkdir()
    fs.remove(fs.file(mainWorldFolder, "stats"), true)

    moveEvent.unregister()

    resetting = false
end
