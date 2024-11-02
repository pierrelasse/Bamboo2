local EntitySpawnEvent = classFor("org.bukkit.event.entity.EntitySpawnEvent")
local TNTPrimed = classFor("org.bukkit.entity.TNTPrimed")

addEvent(EntitySpawnEvent, function(event)
    local entity = event.getEntity()
    if instanceof(entity, TNTPrimed) then
        if entity.getLocation().getWorld().getEntitiesByClass(TNTPrimed).size() > 30 then
            entity.remove()
        end
    end
end)
