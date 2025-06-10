local PlayerJoinEvent = import("org.bukkit.event.player.PlayerJoinEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    local url = "https://bluept.net/cdn2/Bamboo2-Resources.zip"
    ---@type JavaObject
    local sha1
    local function setSha1(hash)
        sha1 = Bamboo.Helper.sha1FromStr(hash)
    end
    setSha1("20b075a3458e1b9935e51450c63e6032c3f4c779")

    service:task("set_url", function(sender, args)
        url = args[3] or ""
        bukkit.send(sender, "§7URL set to: §r"..url)
    end)

    service:task("set_sha1", function(sender, args)
        setSha1(args[3] or "")
        bukkit.send(sender, "§7Sha1 set to: §r"..sha1)
    end)

    service:event(PlayerJoinEvent, function(event)
        local message = bukkit.hex(
            "§#1CFF31§lBenötigte Assets für Bamboo!"
        )
        local player = event.getPlayer()
        player.setResourcePack(url, sha1, message, not player.isOp())
    end)
end
