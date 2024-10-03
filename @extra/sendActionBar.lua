local ChatMessageType = classFor("net.md_5.bungee.api.ChatMessageType")
local TextComponent = classFor("net.md_5.bungee.api.chat.TextComponent")


return function(player, message)
    player.spigot().sendMessage(ChatMessageType.ACTION_BAR, TextComponent.fromLegacy(message))
end
