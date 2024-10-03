local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")
local PlayerQuitEvent = classFor("org.bukkit.event.player.PlayerQuitEvent")


local logger = require("app/util/logger").new("JoinQuitMsgs")

addEvent(PlayerJoinEvent, function(event)
    event.setJoinMessage(nil)
    local name = event.getPlayer().getName()
    logger:debug(name.." joined")
end)

addEvent(PlayerQuitEvent, function(event)
    event.setQuitMessage(nil)
    local name = event.getPlayer().getName()
    logger:debug(name.." left")
end)
