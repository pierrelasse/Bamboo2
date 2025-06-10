---@param entityType string
local function get(entityType)
    return bukkit.material(entityType.."_SPAWN_EGG") or bukkit.material("MOB_SPAWNER")
end

return get
