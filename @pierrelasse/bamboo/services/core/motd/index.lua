local ServerListPingEvent = classFor("org.bukkit.event.server.ServerListPingEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.meta_type = "core"

    local motd = bukkit.hex(
        "§#DE2477  §lB§#DB2190§la§#D81FA9§lm§#D41CC3§lb§#D11ADC§lo§#CE17F5§lo\n"..
        "§7    Nico der lappen soll mal endlich on kommen!"
    )

    service:event(ServerListPingEvent, function(event)
        event.setMotd(motd)
    end)

    service:task("set_motd", function(sender, args)
        local input = table.concat(args, " ", 3) or ""
        motd = bukkit.hex(input)
        bukkit.send(sender, "§aMOTD changed!")
    end)
end
