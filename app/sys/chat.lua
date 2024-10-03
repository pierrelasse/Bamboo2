local Bukkit = classFor("org.bukkit.Bukkit")
local AsyncPlayerChatEvent = classFor("org.bukkit.event.player.AsyncPlayerChatEvent")


addEvent(AsyncPlayerChatEvent, function(event)
    event.setCancelled(true)
    local player = event.getPlayer()
    Bukkit.broadcastMessage(player.getName().."§f: "..event.getMessage())
end)
