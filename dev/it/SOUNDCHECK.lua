return function(player)
    for i = 1, 10 do
        wait(i, function()
            bukkit.playSound(player, "minecraft:block.anvil.land", 1, i / 10)
        end)
    end
end
