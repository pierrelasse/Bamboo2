local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")

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

---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"
    service.exports = {}

    local ranks = {
        dev = {
            sort = numToLetter(1),
            tab = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA%s"),
            ntPrefix = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA"),
            chPrefix = bukkit.hex("§#2C3434[§r瀅§#2C3434] §#3ED9BA"),
        },
        vip = {
            sort = numToLetter(2),
            tab = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA%s"),
            ntPrefix = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA"),
            chPrefix = bukkit.hex("§#3D2A41[§r瀂§#3D2A41] §#C342DA"),
        },
        default = {
            sort = numToLetter(3),
            tab = "%s",
            ntPrefix = "",
            chPrefix = "",
        },
    }

    function service.exports.getRankData(name)
        if name == "pierrelasse" or name == "No1KnowsMyName_" then
            return ranks.dev
        end
        if name == "Cybergamer_1_" then
            return ranks.vip
        end
        return ranks.default
    end

    function service.exports.getFormattedName(name)
        local data = service.exports.getRankData(name)
        return data.chPrefix..name
    end

    function service.exports.updatePlayer(player)
        local name = player.getName()
        local data = service.exports.getRankData(name)

        simpleteams.getPlayerTeam(player, data.sort)
        simpleteams.setPlayerListName(player, string.format(data.tab, name))
        simpleteams.setNametagPrefix(player, data.ntPrefix)
    end

    service:event(PlayerJoinEvent, function(event)
        local player = event.getPlayer()
        service.exports.updatePlayer(player)
    end)

    service.onEnable = function()
        for player in bukkit.onlinePlayersLoop() do
            service.exports.updatePlayer(player)
        end
    end
end
