local EntityType = classFor("org.bukkit.entity.EntityType")
local Location = classFor("org.bukkit.Location")
local Vector = classFor("org.bukkit.util.Vector")
local Double = classFor("java.lang.Double")


local TYPE = EntityType.CREEPER


return function(player)
    local centerLoc = player.getLocation()
    local world = centerLoc.getWorld()
    local centerX, centerY, centerZ = centerLoc.getX(), centerLoc.getY(), centerLoc.getZ()

    local function mode2()
        local vel = player.getEyeLocation().getDirection().multiply(5)
        local loc = Location(nil, centerX, centerY, centerZ)



        local function velocity_xz(speed, angle)
            local rad_angle = math.rad(angle)
            local vx = speed * math.cos(rad_angle)
            local vz = speed * math.sin(rad_angle)
            return vx, vz
        end

        local speed = math.random(3, 10)

        for angle = 0, 360, 60 do
            local entity = world.spawnEntity(loc, TYPE)
            local vx, vz = velocity_xz(speed, angle)
            entity.setVelocity(Vector(vx, -1, vz))
            entity.setExplosionRadius(32)
            entity.setMaxFuseTicks(120 + angle)
            entity.setFuseTicks(0)
            entity.setPowered(true)
            entity.setInvulnerable(true)
            entity.ignite()
        end
    end

    mode2()
end
