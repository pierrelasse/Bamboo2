local Bukkit = classFor("org.bukkit.Bukkit")
local AsyncPlayerChatEvent = classFor("org.bukkit.event.player.AsyncPlayerChatEvent")

local emojis = require("@pierrelasse/bamboo/services/core/chat/emojis")
local ranks = require("@pierrelasse/bamboo/services/core/chat/ranks")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    local emojisEnabled = true

    service:event(AsyncPlayerChatEvent, function(event)
        event.setCancelled(true)

        local player = event.getPlayer()
        local name = player.getName()
        local message = event.getMessage()

        name = ranks.chatFormatName(name)

        Bukkit.broadcastMessage(name.."§f: "..message)
    end)

    service:addTask("emojis", function(sender, args)
        emojisEnabled = not emojisEnabled
        bukkit.send(sender, "§7Emojis are now "..(emojisEnabled and "§aenabled" or "§cdisabled"))
    end)
end
