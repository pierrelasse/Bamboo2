local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")

local simpleteams = require("@bukkit/scoreboard/simpleteams")
local specialChars = require("@pierrelasse/bamboo/util/specialChars")


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

    service.onEnable = function()
        service.exports = {}

        local ranks = {
            dev = {
                sort = numToLetter(1),
                tab = bukkit.hex("§#2C3434[§r"..specialChars.rank_dev.."§#2C3434] §#F25879%s"),
                ntPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_dev.."§#2C3434] §#F25879"),
                chPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_dev.."§#2C3434] §#F25879"),
            },
            team = {
                sort = numToLetter(2),
                tab = bukkit.hex("§#2C3434[§r"..specialChars.rank_team.."§#2C3434] §#7B82EA%s"),
                ntPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_team.."§#2C3434] §#7B82EA"),
                chPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_team.."§#2C3434] §#7B82EA"),
            },
            mod = {
                sort = numToLetter(3),
                tab = bukkit.hex("§#2C3434[§r"..specialChars.rank_mod.."§#2C3434] §#14CB01%s"),
                ntPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_mod.."§#2C3434] §#14CB01"),
                chPrefix = bukkit.hex("§#2C3434[§r"..specialChars.rank_mod.."§#2C3434] §#14CB01"),
            },
            vip = {
                sort = numToLetter(4),
                tab = bukkit.hex("§#3D2A41[§r"..specialChars.rank_vip.."§#3D2A41] §#FF0090%s"),
                ntPrefix = bukkit.hex("§#3D2A41[§r"..specialChars.rank_vip.."§#3D2A41] §#FF0090"),
                chPrefix = bukkit.hex("§#3D2A41[§r"..specialChars.rank_vip.."§#3D2A41] §#FF0090"),
            },
            default = {
                sort = numToLetter(5),
                tab = "%s",
                ntPrefix = "",
                chPrefix = "",
            },
        }

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

        function service.exports.getRankData(name)
            if name == "pierrelasse" or "No1KnowsMyName_" then
                return ranks.dev
            end
            if name == "Cybergamer_1_" then
                return ranks.vip
            end
            return ranks.default
        end

        for player in bukkit.onlinePlayersLoop() do
            service.exports.updatePlayer(player)
        end
    end

    service.onDisable = function()
        for player in bukkit.onlinePlayersLoop() do
            local team = simpleteams.getPlayerTeam(player)
            if team ~= nil then
                team.unregister()
            end
            simpleteams.setPlayerListName(player, nil)
        end

        service.exports = nil
    end

    service:event(PlayerJoinEvent, function(event)
        local player = event.getPlayer()
        service.exports.updatePlayer(player)
    end)
end
