local ChatColor = classFor("org.bukkit.ChatColor")
local Criteria = classFor("org.bukkit.scoreboard.Criteria")
local DisplaySlot = classFor("org.bukkit.scoreboard.DisplaySlot")
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

local RANK_1 = {
    sort = numToLetter(1),
    tab = "§c§lADMIN §c%s",
    ntPrefix = "§c§lADMIN §c",
    ntColor = "RED",
    ntSuffix = " §8[§eCUM§8]"
}
local RANK_2 = {
    sort = numToLetter(2),
    tab = "§7§lMEMBER §7%s",
    ntPrefix = "§7§lMEMBER §7",
    ntColor = "GRAY",
    ntSuffix = ""
}
local rankData = {}
local function getPlayerData(name)
    return rankData[name] or RANK_2
end

local function updatePlayer(player)
    local name = player.getName()
    local data = getPlayerData(name)
    if data == nil then return end

    simpleteams.getPlayerTeam(player, data.sort)
    simpleteams.setPlayerListName(player, string.format(data.tab, name))
    simpleteams.setNametagPrefix(player, data.ntPrefix)
    simpleteams.setNametagColor(player, data.ntColor)
    simpleteams.setNametagSuffix(player, data.ntSuffix)
end

addEvent(PlayerJoinEvent, function(event)
    updatePlayer(event.getPlayer())
end)

every(20, function()
    for player in bukkit.onlinePlayersLoop() do
        updatePlayer(player)
    end
end)

do
    local objective = sbmanager.sb.registerNewObjective("a", Criteria.HEALTH, "§c❤")
    objective.setDisplaySlot(DisplaySlot.BELOW_NAME)
end


return function(player, args)
    local rank
    if args[2] == "1" then
        rank = RANK_1
    else
        rank = RANK_2
    end
    rankData[player.getName()] = rank
    updatePlayer(player)
end
