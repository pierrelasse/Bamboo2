require("@bukkit/index")


---@return JavaObject players java.util.Collection<? extends Player>
function bukkit.onlinePlayers()
    return bukkit.Bukkit.getOnlinePlayers()
end

---### Usage
---```lua
---for player in bukkit.onlinePlayersLoop() do
---end
---```
---
---@return fun():JavaObject player org.bukkit.entity.Player
function bukkit.onlinePlayersLoop()
    return forEach(bukkit.onlinePlayers())
end
