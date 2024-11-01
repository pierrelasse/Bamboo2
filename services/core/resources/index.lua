local PlayerJoinEvent = classFor("org.bukkit.event.player.PlayerJoinEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    local url = "https://bluept.net/cdn2/Bamboo2-Resources.zip"
    local sha1 = "79bceeb09259117a744fb45a7d77a4b0d5ccb493"

    -- service:event(PlayerJoinEvent, function(event)
    --     local player = event.getPlayer()
    --     player.setResourcePack(url, sha1)
    -- end)

    service:addTask("set_url", function(sender, args)
        url = args[3] or ""
        bukkit.send(sender, "§7URL set to: §r"..url)
    end)

    service:addTask("set_sha1", function(sender, args)
        sha1 = args[3] or ""
        bukkit.send(sender, "§7Sha1 set to: §r"..sha1)
    end)
end
