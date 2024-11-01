local Sidebar = require("@bukkit/scoreboard/Sidebar")


return function(player)
    local function wichtig(value)
        local title = bukkit.hex(string.format("§#%02X%02X%02X", value, value, value)).."瀒"
        for p in bukkit.onlinePlayersLoop() do
            local sb = Sidebar.get(p)
            sb:setTitle(title)
        end
    end
    local time = 0
    for i = 0, 255, 5 do
        wait(time, function()
            wichtig(i)
        end)
        time = time + 1
    end
end
