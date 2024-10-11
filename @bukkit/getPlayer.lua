local UUID = classFor("java.util.UUID")

require("@bukkit/index")


---@param name string
---@return JavaObject|nil player org.bukkit.entity.Player
function bukkit.getPlayer(name)
    return bukkit.Bukkit.getPlayerExact(name)
end

---@param name string
---@return JavaObject|nil player org.bukkit.entity.Player
function bukkit.getPlayerClosest(name)
    return bukkit.Bukkit.getPlayer(name)
end

function bukkit.getPlayerByUUIDObj(uuid)
    return instanceof(uuid, UUID) and bukkit.Bukkit.getPlayer(uuid) or nil
end

---@param uuid string
---@return JavaObject|nil player org.bukkit.entity.Player)
function bukkit.getPlayerByUUID(uuid)
    return bukkit.getPlayerByUUIDObj(uuid)
end
