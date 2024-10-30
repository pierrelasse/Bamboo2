local Player = classFor("org.bukkit.entity.Player")

require("@bukkit/onlinePlayers")
require("@bukkit/getPlayer")


local _targets = {}

local function checkSee(sender, target)
    return sender.canSee(target)
end

---@param sender JavaObject
---@param completions JavaObject
---@param arg string
_targets.complete = function(sender, completions, arg)
    for player in bukkit.onlinePlayersLoop() do
        if checkSee(sender, player) then
            local name = player.getName()
            if string.startswith(name, arg) then
                completions.add(name)
            end
        end
    end
end

---@param sender JavaObject
---@param arg string
---@param default JavaObject|nil
_targets.find = function(sender, arg, default)
    local player = arg ~= nil and bukkit.getPlayer(arg) or nil
    if player == nil then
        if instanceof(default, Player) then
            return default
        end
        return
    end
    if checkSee(sender, player) then
        return player
    end
end


return _targets
