local GameMode = classFor("org.bukkit.GameMode")
local Player = classFor("org.bukkit.entity.Player")

require("@bukkit/getPlayer")
require("@bukkit/onlinePlayers")
require("@bukkit/send")
require("@core/util/table")


local PERMISSION = "plugins.gamemode.command"
local GAMEMODE_MAP = {
    [GameMode.SURVIVAL]  = { "survival", "s", "0" },
    [GameMode.CREATIVE]  = { "creative", "c", "1" },
    [GameMode.ADVENTURE] = { "adventure", "a", "2" },
    [GameMode.SPECTATOR] = { "spectator", "sp", "3" },
}


---@param args string[]
---@param index integer
---@param default JavaObject
---@return JavaObject|nil
local function getTarget(args, index, default)
    local targetName = args[index]
    local target = targetName == nil and default or bukkit.getPlayer(targetName)
    if instanceof(target, Player) then return target end
end

local function sendSuccessMessage(sender, target, gamemode)
    local stringifiedGameMode = GAMEMODE_MAP[gamemode][1]
    if target == sender then
        bukkit.send(sender, "§aSet gamemode to §2"..stringifiedGameMode)
    else
        bukkit.send(sender, "§aSet gamemode of §2"..target.getName().."§a to §2"..stringifiedGameMode)
    end
end

local function completeTarget(sender, completions, arg)
    for player in bukkit.onlinePlayersLoop() do
        local name = player.getName()
        if (arg == nil or string.startswith(name, arg)) and sender.canSee(player) then
            completions.add(name)
        end
    end
end

local function registerCommandStandard(name, gamemode)
    addCommand(name, function(sender, args)
        local target = getTarget(args, 1, sender)
        if target == nil then
            bukkit.send(sender, "§cInvalid target")
            return
        end
        target.setGameMode(gamemode)
        sendSuccessMessage(sender, target, gamemode)
    end)
        .permission(PERMISSION)
        .complete(function(completions, sender, args)
            if #args == 1 then
                completeTarget(sender, completions, args[1])
            end
        end)
end

for gamemode, values in pairs(GAMEMODE_MAP) do
    registerCommandStandard("gm"..values[2], gamemode)
end

addCommand("gm", function(sender, args)
    local gamemode
    for loopGameMode, values in pairs(GAMEMODE_MAP) do
        local key = table.key(values, args[1])
        if key ~= nil then
            gamemode = loopGameMode
            break
        end
    end
    if gamemode == nil then
        bukkit.send(sender, "§cInvalid gamemode")
        return
    end

    local target = getTarget(args, 2, sender)
    if target == nil then
        bukkit.send(sender, "§cInvalid target")
        return
    end

    target.setGameMode(gamemode)
    sendSuccessMessage(sender, target, gamemode)
end)
    .permission(PERMISSION)
    .complete(function(completions, sender, args)
        if #args == 1 then
            for i in forEach(GameMode.values()) do
                completions.add(string.lower(i.toString()))
            end
        elseif #args == 2 then
            completeTarget(sender, completions, args[2])
        end
    end)
