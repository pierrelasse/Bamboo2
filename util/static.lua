local Bukkit = classFor("org.bukkit.Bukkit")
local MiniMessage = classFor("net.kyori.adventure.text.minimessage.MiniMessage")

function ToMiniMessage(input)
    return MiniMessage.miniMessage().deserialize(input)
end

function Send(player, message)
    player.sendMessage(message)
end

function SendActionBar(player, input)
    player.sendActionBar(ToMiniMessage(input))
end

function BroadcastActionBar(input)
    local component = ToMiniMessage(input)
    for player in bukkit.onlinePlayersLoop() do
        player.sendActionBar(component)
    end
end

---@param player JavaObject
---@param sound string
---@param pitch number? 0-1
---@param volume number? 0-1
function PlaySound(player, sound, pitch, volume)
    player.playSound(player.getLocation(), sound, volume or 1, pitch or 1)
end
