-- local function animatedTitle(player, title, subtitle)
--     local titleLen = string.len(title)
--     local subtitleLen = string.len(subtitle)
--     local length, length2 = subtitleLen, titleLen

--     local amt
--     if length > length2 then amt = length end
--     if length < length2 then amt = length2 end

--     local loopcount = 0
--     local function loop(i)
--         loopcount = loopcount + 1

--         local send = loopcount <= length and string.sub(subtitle, 1, loopcount) or ""
--         local send2 = loopcount <= length2 and string.sub(title, 1, loopcount) or ""

--         local a = loopcount <= length and string.sub(send, 1, loopcount - 1) or ""
--         if loopcount < length then
--             send = string.replace(send, a, a.."§k")
--         end
--         local b = loopcount <= length and string.sub(send2, 1, loopcount - 1) or ""
--         if loopcount < length2 then
--             send2 = string.replace(send2, b, b.."§k")
--         end

--         player.sendTitle(send2, send, 0, 25, 10)

--         wait(1, function()
--             if i == 0 then return end
--             loop(i - 1)
--         end)
--     end
--     loop(amt)
-- end

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
    -- animatedTitle(player, "§#bb07dbVitara", "This is your Element!",
    --               { id = "block.stone_button.click_on", volume = 0.5 })
end
