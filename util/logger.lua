local logger = {}
logger.__index = logger

function logger.new(sys)
    local self = setmetatable({}, logger)
    self.sys = sys
    return self
end

Bamboo.logger = logger.new

function logger:broadcast(rawMessage)
    for player in bukkit.onlinePlayersLoop() do
        if player.getName() == "pierrelasse" or player.getName() == "No1KnowsMyName_" then -- TODO: less cracky
            player.sendMessage(rawMessage)
            break
        end
    end
end

function logger:debug(message)
    self:broadcast("§8[DEBUG] "..self.sys.." # §7"..message)
end

return logger
