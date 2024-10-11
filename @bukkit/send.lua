local ChatMessageType = classFor("net.md_5.bungee.api.ChatMessageType")
local TextComponent = classFor("net.md_5.bungee.api.chat.TextComponent")

require("@bukkit/index")


function bukkit.sendComponent(player, component)
    player.spigot().sendMessage(component)
end

function bukkit.send(player, message)
    bukkit.sendComponent(player, TextComponent.fromLegacy(message))
end

function bukkit.sendActionBarComponent(player, component)
    player.spigot().sendMessage(ChatMessageType.ACTION_BAR, component)
end

function bukkit.sendActionBar(player, message)
    bukkit.sendActionBarComponent(player, TextComponent.fromLegacy(message))
end

---@param player JavaObject
---@param title string|nil
---@param subtitle string|nil
---@param fadeIn integer
---@param stay integer
---@param fadeOut integer
function bukkit.sendTitle(player, title, subtitle, fadeIn, stay, fadeOut)
    if fadeIn == nil then
        player.sendTitle(player, title, subtitle)
    else
        player.sendTitle(player, title, subtitle, fadeIn, stay, fadeOut)
    end
end
