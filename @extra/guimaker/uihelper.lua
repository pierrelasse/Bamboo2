local ArrayList = classFor("java.util.ArrayList")
local Material = classFor("org.bukkit.Material")
local ItemStack = classFor("org.bukkit.inventory.ItemStack")

local uihelper = {}

function uihelper.item(material, name, lore)
    local itemStack = ItemStack(Material.valueOf(material))
    local meta = itemStack.getItemMeta()
    if meta ~= nil then
        if name ~= nil then
            meta.setDisplayName(name)
        end
        if lore ~= nil then
            local list = ArrayList()
            for _, line in ipairs(lore) do list.add(line) end
            meta.setLore(list)
        end
        itemStack.setItemMeta(meta)
    end
    return itemStack
end

return uihelper
