local Bukkit = classFor("org.bukkit.Bukkit")


local logger = {}
logger.__index = logger

function logger.new(sys)
    local self = setmetatable({}, logger)
    self.sys = sys
    return self
end

function logger:broadcast(rawMessage)
    for player in forEach(Bukkit.getOnlinePlayers()) do
        if player.getName() == "pierrelasse" or player.getName() == "LCHEETAH" then -- TODO: less cracky
            player.sendMessage(rawMessage)
            break
        end
    end
end

function logger:debug(message)
    self:broadcast("§8[DEBUG] "..self.sys.." # §7"..message)
end

return logger
