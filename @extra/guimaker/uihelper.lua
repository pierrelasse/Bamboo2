local UUID = classFor("java.util.UUID")
local ArrayList = classFor("java.util.ArrayList")
local GameProfile = classFor("com.mojang.authlib.GameProfile")
local Property = classFor("com.mojang.authlib.properties.Property")
local ResolvableProfile = classFor("net.minecraft.world.item.component.ResolvableProfile")
local Material = classFor("org.bukkit.Material")
local ItemStack = classFor("org.bukkit.inventory.ItemStack")


local uihelper = {}

---@param material JavaObject|string org.bukkit.Material|"HEAD:<texture>"
---@param name string|nil
---@param lore string[]|nil
---@return JavaObject itemStack org.bukkit.inventory.ItemStack
function uihelper.item(material, name, lore)
    local itemStack, meta

    if string.startswith(material, "HEAD:") then
        itemStack = ItemStack(Material.PLAYER_HEAD)
        meta = itemStack.getItemMeta()
        local uuid = UUID.fromString("00000000-0000-0000-0000-000000000000")
        local profile = GameProfile(uuid, "")
        local texture = string.sub(material, 6)
        local property = Property("textures", texture)
        profile.getProperties().put("textures", property)
        if ResolvableProfile ~= nil then
            profile = ResolvableProfile(profile)
        end
        meta.setProfile(profile)
    else
        itemStack = ItemStack(Material.valueOf(material))
        meta = itemStack.getItemMeta()
        if meta == nil then return itemStack end
    end

    if name ~= nil then
        meta.setDisplayName(name)
    end

    if lore ~= nil then
        local list = ArrayList()
        for _, line in ipairs(lore) do list.add(line) end
        meta.setLore(list)
    end

    itemStack.setItemMeta(meta)

    return itemStack
end

return uihelper
