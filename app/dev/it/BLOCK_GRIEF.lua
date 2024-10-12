local BlockBreakEvent = classFor("org.bukkit.event.block.BlockBreakEvent")


local AIR = classFor("org.bukkit.Material").AIR


return function(player)
    local function breek(world, x, y, z, i)
        local block = world.getBlockAt(x, y, z)
        if block.getType().name() == "AIR" then
            return
        end
        block.setType(AIR, false)

        i = i - 1
        if i == 0 then return end

        wait(3, function()
            breek(world, x + 1, y, z, i)
            breek(world, x, y, z + 1, i)
            breek(world, x - 1, y, z, i)
            breek(world, x, y, z - 1, i)
            breek(world, x, y + 1, z, i)
            breek(world, x, y - 1, z, i)
        end)
    end

    addEvent(BlockBreakEvent, function(event)
        local block = event.getBlock()
        breek(block.getWorld(), block.getX(), block.getY(), block.getZ(), 30)
    end)
end
