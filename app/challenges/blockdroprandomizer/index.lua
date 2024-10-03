local Material = classFor("org.bukkit.Material")
local ItemStack = classFor("org.bukkit.inventory.ItemStack")
local BlockBreakEvent = classFor("org.bukkit.event.block.BlockBreakEvent")


---@param challenge app.challenge.Challenge
return function(challenge)
    local cache = {}
    local availableMaterials = {}

    for material in forEach(Material.values()) do
        if material.isItem() and not material.isLegacy() then
            availableMaterials[#availableMaterials + 1] = material
        end
    end

    function challenge.onReset()
        cache = {}
    end

    ---@type ScriptEvent
    local ev
    function challenge.onEnable()
        ev = addEvent(BlockBreakEvent, function(event)
            event.setDropItems(false)

            local block = event.getBlock()
            local loc = block.getLocation()

            local id = block.getType().name()
            local material = cache[id]
            if material == nil then
                material = table.randomElement(availableMaterials)
                cache[id] = material
            end
            local itemStack = ItemStack(material)
            loc.getWorld().dropItemNaturally(loc, itemStack)
        end)
    end

    function challenge.onDisable()
        ev.unregister()
    end
end
