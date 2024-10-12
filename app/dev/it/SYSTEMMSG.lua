local ChatMessageType = classFor("net.md_5.bungee.api.ChatMessageType")
local TextComponent = classFor("net.md_5.bungee.api.chat.TextComponent")


return function(player)
    player.spigot().sendMessage(ChatMessageType.SYSTEM, TextComponent.fromLegacy("message"))
end
