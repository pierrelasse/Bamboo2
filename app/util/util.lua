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
    for player in forEach(Bukkit.getOnlinePlayers()) do
        player.sendActionBar(component)
    end
end
