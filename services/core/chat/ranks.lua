local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")

local sbmanager = require("@bukkit/scoreboard/sbmanager")
local simpleteams = require("@bukkit/scoreboard/simpleteams")


local function numToLetter(num)
    if num < 1 then return "" end
    local result = ""
    while num > 0 do
        num = num - 1
        result = string.char((num % 26) + 65)..result
        num = math.floor(num / 26)
    end
    return result
end

local ranks = {}

local RANK_DEV = {
    sort = numToLetter(1),
    tab = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA%s"),
    ntPrefix = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA"),
    chPrefix = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA"),
}

local RANK_VIP = {
    sort = numToLetter(2),
    tab = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA%s"),
    ntPrefix = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA"),
    chPrefix = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA"),
}

local RANK_NORMAL = {
    sort = numToLetter(3),
    tab = "%s",
    ntPrefix = "",
    chPrefix = "",
}

function ranks.getRankData(name)
    if name == "No1KnowsMyName_" then
        return RANK_VIP
    end
    if name == "pierrelasse" or name == "No1KnowsMyName_" then
        return RANK_DEV
    end
    if name == "Cybergamer_1_" then
        return RANK_VIP
    end
    return RANK_NORMAL
end

function ranks.chatFormatName(name)
    local data = ranks.getRankData(name)
    return data.chPrefix..name
end

function ranks.updatePlayer(player)
    local name = player.getName()
    local data = ranks.getRankData(name)

    simpleteams.getPlayerTeam(player, data.sort)
    simpleteams.setPlayerListName(player, string.format(data.tab, name))
    simpleteams.setNametagPrefix(player, data.ntPrefix)
end

do
    addEvent(PlayerJoinEvent, function(event)
        local player = event.getPlayer()
        ranks.updatePlayer(player)
    end)

    for player in bukkit.onlinePlayersLoop() do
        ranks.updatePlayer(player)
    end
end

return ranks
