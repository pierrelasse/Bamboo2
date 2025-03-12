local PlayerScoreboard = require("@extra/PlayerScoreboard")


local function rainbowText(text, offset)
    local result = ""
    local length = #text

    for i = 1, length do
        -- Calculate color based on character position and offset
        local r = (math.sin((i + offset) * 0.3) * 127 + 128)     -- R component
        local g = (math.sin((i + offset) * 0.3 + 2) * 127 + 128) -- G component
        local b = (math.sin((i + offset) * 0.3 + 4) * 127 + 128) -- B component

        local hex = string.format("%02X%02X%02X", r, g, b)
        local color = "§x§"..hex:sub(1, 1).."§"..hex:sub(2, 2)..
            "§"..hex:sub(3, 3).."§"..hex:sub(4, 4)..
            "§"..hex:sub(5, 5).."§"..hex:sub(6, 6)
        result = result..color..text:sub(i, i)
    end

    return result
end

local c = 0
local change = 1

every(2, function()
    for player in bukkit.onlinePlayersLoop() do
        local sb = PlayerScoreboard.get(player)

        sb:setTitle(bukkit.components.convertHex("§#6ECFE7§l§n§nhttps://youtu.be/xXTl6ve9yh8 §#906EE7<-- Wichtig!1"))

        local lines = {}
        for i = 0, 14, 1 do
            local key =
            "Das Leben macht extremst spass. ChatGPT ist eine toller Erfindung. Minecraft, Mojang und Microsoft ist super toll. Fusion 360 ist performant."
            key = rainbowText(key, c + i)
            lines[#lines + 1] = key
        end
        sb:setScores(lines)
    end

    c = c + change
    if c > 15 then
        change = -1
        c = 15
    elseif c < 0 then
        change = 1
        c = 0
    end
end)


return function() end
