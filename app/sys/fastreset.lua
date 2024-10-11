local Bukkit = classFor("org.bukkit.Bukkit")
local Location = classFor("org.bukkit.Location")
local GameMode = classFor("org.bukkit.GameMode")
local PlayerPortalEvent = classFor("org.bukkit.event.player.PlayerPortalEvent")
local PlayerRespawnEvent = classFor("org.bukkit.event.player.PlayerRespawnEvent")
local PlayerMoveEvent = classFor("org.bukkit.event.player.PlayerMoveEvent")
local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")

local fs = require("@base/fs")
local worldmanager = require("@bukkit/worldmanager/worldmanager")
local serviceManager = require("app/service/serviceManager")

local resetting = false

local mainWorld = Bukkit.getWorlds().get(0)

local FAKE_WORLD_ID = "gameworld"
local fakeWorld = worldmanager.get(FAKE_WORLD_ID)
if fakeWorld == nil then
    print("creating game world")
    local creator = worldmanager.create(FAKE_WORLD_ID)
    if serviceManager.worldGenOverworld ~= nil then
        creator:setGenerator(serviceManager.worldGenOverworld)
    end
    fakeWorld = creator:create()
end
local awaitLocation = Location(mainWorld, 0, -10000, 0, 0, 90)


addEvent(PlayerPortalEvent, function(event)
    local to = event.getTo()
    if to.getWorld() == mainWorld then
        to.setWorld(fakeWorld)
        event.setTo(to)
    end
end)

addEvent(PlayerRespawnEvent, function(event)
    if event.getRespawnLocation().getWorld() == mainWorld then
        event.setRespawnLocation(fakeWorld.getSpawnLocation().clone().add(.5, 0, .5))
        print("??")
    end
    print("ee")
end)

addEvent(PlayerJoinEvent, function(event)
    local player = event.getPlayer()
    if resetting then
        player.kickPlayer("")
        return
    end

    if not player.hasPlayedBefore() then
        local loc = fakeWorld.getSpawnLocation().clone().add(.5, 0, .5)
        player.setRespawnLocation(loc)
        player.teleport(loc)
        player.resetTitle()
    end
end)


function FastReset(sender)
    if resetting or not sender.isOnline() then return end
    resetting = true

    Timer.reset()

    BroadcastActionBar("Reset von "..sender.getName().." veranlasst")

    for player in bukkit.onlinePlayersLoop() do
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

        for player in bukkit.onlinePlayersLoop() do
            player.sendTitle(progress, "§lWelten werden zurückgesetzt", 0, 999999, 0)
        end
    end
    doTitle(0, 6)


    local moveEvent = addEvent(PlayerMoveEvent, function(event)
        event.setTo(awaitLocation)
    end)

    do
        worldmanager.delete(FAKE_WORLD_ID)
        doTitle(1, 6)
        local creator = worldmanager.create(FAKE_WORLD_ID)
        fakeWorld = creator:create()
    end
    doTitle(2, 6)
    do
        worldmanager.delete("world_nether")
        doTitle(3, 6)
        local creator = worldmanager.create("world_nether")
        creator:setEnvironment(-1)
        if serviceManager.worldGenNether ~= nil then
            creator:setGenerator(serviceManager.worldGenNether)
        end
        creator:create()
    end
    doTitle(4, 6)
    do
        worldmanager.delete("world_the_end")
        doTitle(5, 6)
        local creator = worldmanager.create("world_the_end")
        creator:setEnvironment(1)
        if serviceManager.worldGenEnd ~= nil then
            creator:setGenerator(serviceManager.worldGenEnd)
        end
        creator:create()
    end
    doTitle(6, 6)

    do
        local m = "§lServer Reset"
        m = m.."\n§7Der Server wurde zurückgesetzt."
        m = m.."\n§7Du kannst direkt wieder verbinden."
        m = m.."\n"
        for player in bukkit.onlinePlayersLoop() do
            player.kickPlayer(m)
        end
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
