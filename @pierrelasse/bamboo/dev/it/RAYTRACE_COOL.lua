local Location = classFor("org.bukkit.Location")
local Particle = classFor("org.bukkit.Particle")
local EntityType = classFor("org.bukkit.entity.EntityType")
local Transformation = classFor("org.bukkit.util.Transformation")
local AxisAngle4f = classFor("org.joml.AxisAngle4f")
local Vector3f = classFor("org.joml.Vector3f")


-- https://discord.com/channels/135877399391764480/1072217309852213298/1261890051411804223


local collideCache = {}

---@param world JavaObject
---@param x number
---@param y number
---@param z number
---@return boolean collided
local function collides(world, x, y, z)
    local cache = collideCache[world]
    if cache == nil then
        cache = {}
        collideCache[world] = cache
    end

    x = math.floor(x)
    y = math.floor(y)
    z = math.floor(z)

    local key = x..","..y..","..z

    local cachedResult = cache[key]
    if cachedResult == nil then
        local block = world.getBlockAt(x, y, z)
        local type = block.getType().name()
        cachedResult = type == "BARRIER"
        cache[key] = cachedResult
    end

    return cachedResult
end

---@param world JavaObject
---@param x number
---@param y number
---@param z number
local function spawnBall(world, x, y, z)
    local loc = Location(world, x, y, z)
    local entType = EntityType.BLOCK_DISPLAY
    local ent = loc.getWorld()
        .spawnEntity(loc, entType)
    ent.addScoreboardTag("temp")

    local blockData = bukkit.Bukkit.createBlockData(bukkit.material("WHITE_CONCRETE"))
    ent.setBlock(blockData)
    ent.setTransformation(Transformation(
        Vector3f(),
        AxisAngle4f(),
        Vector3f(.1, .1, .1),
        AxisAngle4f()
    ))
end

---@param world JavaObject
---@param x number
---@param y number
---@param z number
---@param yaw number
---@param pitch number
---@param stepSize number
---@param maxDistance number
local function raytrace(world, x, y, z, yaw, pitch, stepSize, maxDistance)
    local yawRad = math.rad(yaw)
    local pitchRad = math.rad(pitch)

    local dirX = -math.sin(yawRad) * math.cos(pitchRad)
    local dirZ = math.cos(yawRad) * math.cos(pitchRad)
    local dirY = -math.sin(pitchRad)

    local distance = 0

    while distance < maxDistance do
        x = x + dirX * stepSize
        y = y + dirY * stepSize
        z = z + dirZ * stepSize
        distance = distance + stepSize

        -- do
        --     local loc = bukkit.location3(x, y, z)
        --     world.spawnParticle(Particle.FLAME, loc, 1, 0, 0, 0, 0, nil)
        -- end

        if collides(world, x, y, z) then
            return true, x, y, z
        end
    end

    return false, x, y, z
end

---@param world JavaObject
---@param x number
---@param y number
---@param z number
---@param yaw number
---@param pitch number
local function run(world, x, y, z, yaw, pitch)
    local w = 0
    for pitchOffset = -60, 60, 2 do
        w = w + 1
        wait(w, function()
            for yawOffset = -80, 80, 3 do
                local hit, hitX, hitY, hitZ = raytrace(world, x, y, z, yaw + yawOffset, pitch + pitchOffset, .1, 20)

                if hit then
                    spawnBall(world, hitX, hitY, hitZ)
                end
            end
        end)
    end
end

return function(player, args)
    local loc = player.getLocation()
    local world = loc.getWorld()

    if args[2] == "c" then
        bukkit.send(player, "§6cleaning")

        for entity in forEach(world.getEntities()) do
            if entity.getScoreboardTags().contains("temp") then
                entity.remove()
            end
        end
        return
    end

    bukkit.send(player, "§6performing raytrace")

    run(world, loc.getX(), loc.getY() + 1.3, loc.getZ(), loc.getYaw(), loc.getPitch())
end
