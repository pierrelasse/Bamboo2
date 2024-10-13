local Material = classFor("org.bukkit.Material")
local ItemStack = classFor("org.bukkit.inventory.ItemStack")
local BlockBreakEvent = classFor("org.bukkit.event.block.BlockBreakEvent")

local Storage = require("app/util/Storage")


---@param service app.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "BlockDropRandomizer"
    service.meta_material = "DROPPER"

    local storage = Storage.new(service.id)

    local cache = {}

    storage:loadSave(function()
        storage:set("cache", nil)
        for id, material in pairs(cache) do
            storage:set("cache."..id, material.name())
        end
    end)
    do
        local keys = storage:getKeys("cache")
        if keys ~= nil then
            for id in forEach(keys) do
                local materialStr = storage:get("cache."..id)
                local material = Material.valueOf(materialStr)
                cache[id] = material
            end
        end
    end

    local availableMaterials = {}

    for material in forEach(Material.values()) do
        if material.isItem() and not material.isLegacy() then
            availableMaterials[#availableMaterials + 1] = material
        end
    end

    function service.onReset()
        cache = {}
    end

    ---@type ScriptEvent
    local ev
    function service.onEnable()
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

    function service.onDisable()
        ev.unregister()
    end
end
