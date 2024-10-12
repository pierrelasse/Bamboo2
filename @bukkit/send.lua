local ChatMessageType = classFor("net.md_5.bungee.api.ChatMessageType")


require("@bukkit/index")
require("@bukkit/components/index")


---@param player JavaObject
---@param component JavaObject
function bukkit.sendComponent(player, component)
    player.spigot().sendMessage(component)
end

---@param player JavaObject
---@param message string
function bukkit.send(player, message)
    bukkit.sendComponent(player, bukkit.components.parse(message))
end

---@param player JavaObject
---@param component JavaObject
function bukkit.sendActionBarComponent(player, component)
    player.spigot().sendMessage(ChatMessageType.ACTION_BAR, component)
end

---@param player JavaObject
---@param message string
function bukkit.sendActionBar(player, message)
    bukkit.sendActionBarComponent(player, bukkit.components.parse(message))
end

---@param player JavaObject
---@param title string?
---@param subtitle string?
---@param fadeIn integer?
---@param stay integer?
---@param fadeOut integer?
function bukkit.sendTitle(player, title, subtitle, fadeIn, stay, fadeOut)
    if title ~= nil then title = bukkit.components.convertHex(title) end
    if subtitle ~= nil then subtitle = bukkit.components.convertHex(subtitle) end

    if fadeIn == nil then
        player.sendTitle(title, subtitle)
    else
        player.sendTitle(title, subtitle, fadeIn, stay, fadeOut)
    end
end

---@param player JavaObject
---@param sound string
---@param volume number? = 1
---@param pitch number? = 1
function bukkit.playSound(player, sound, volume, pitch)
    player.playSound(player.getLocation(), sound, volume or 1, pitch or 1)
end
