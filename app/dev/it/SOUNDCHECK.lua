return function(player)
    for i = 1, 10 do
        wait(i, function()
            PlaySound(player, "minecraft:block.anvil.land", i / 10)
        end)
    end
end
