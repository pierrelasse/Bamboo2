local PlayerJoinEvent = import("org.bukkit.event.player.PlayerJoinEvent")
local PlayerQuitEvent = import("org.bukkit.event.player.PlayerQuitEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"
    local logger = service:logger()

    service:event(PlayerJoinEvent, function(event)
        event.setJoinMessage(nil)
        local name = event.getPlayer().getName()
        logger:debug(name.." joined")
    end)

    service:event(PlayerQuitEvent, function(event)
        event.setQuitMessage(nil)
        local name = event.getPlayer().getName()
        logger:debug(name.." left")
    end)
end
