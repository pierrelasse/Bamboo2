local Bukkit = classFor("org.bukkit.Bukkit")
local AsyncPlayerChatEvent = classFor("org.bukkit.event.player.AsyncPlayerChatEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    service:event(AsyncPlayerChatEvent, function(event)
        event.setCancelled(true)

        local player = event.getPlayer()
        local name = player.getName()
        local message = event.getMessage()

        do
            local emojis = Bamboo.serviceManager.get("core/chat-emojis")
            if emojis ~= nil then
                message = emojis(message)
            end
        end

        do
            local ranks = Bamboo.serviceManager.get("core/ranks")
            if ranks ~= nil then
                name = ranks.getFormattedName(name)
            end
        end

        Bukkit.broadcastMessage(name.."§f: "..message)
    end)
end
