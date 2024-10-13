---@param player JavaObject
---@param title string
---@param subtitle string
---@param sound {id: string, volume: number, pitch: number}?
local function animatedTitle(player, title, subtitle, sound)
    local iterations = math.max(#title, #subtitle)
    local iteration = 0

    local function loop()
        iteration = iteration + 1
        player.sendTitle(title:sub(1, iteration), subtitle:sub(1, iteration), 0, 25, 10)
        if sound ~= nil then
            player.playSound(player, sound.id, sound.volume or 1, sound.pitch or 1)
        end
        if iteration < iterations then wait(1, loop) end
    end

    loop()
end


return function(player)
    animatedTitle(player, "§3§lSKILL LEVEL UP!", "§aForaging 3 → Foraging 4")
end
