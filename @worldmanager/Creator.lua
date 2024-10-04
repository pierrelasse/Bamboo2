local WorldCreator = classFor("org.bukkit.WorldCreator")
local World_Environment = classFor("org.bukkit.World$Environment")
local WorldType = classFor("org.bukkit.WorldType")
local VoidWorldGenerator


---@class worldmanager.Creator
---@field worldCreator JavaObject
local Creator = {}
Creator.__index = Creator

---@class worldmanager.Creator.Environment
Creator.Environment = {
    NORMAL = 0,
    NETHER = -1,
    THE_END = 1,
    CUSTOM = -999
}

---@class worldmanager.Creator.Type
Creator.Type = {
    NORMAL = "DEFAULT",
    FLAT = "FLAT",
    LARGE_BIOMES = "LARGEBIOMES",
    AMPLIFIED = "AMPLIFIED"
}

function Creator.new(name)
    local self = setmetatable({}, Creator)
    self.worldCreator = WorldCreator(name)
    return self
end

---@return number seed
function Creator:getSeed()
    return self.worldCreator.seed()
end

---@param seed number
function Creator:setSeed(seed)
    self.worldCreator.seed(seed)
end

---@return number environment
function Creator:getEnvironment()
    return self.worldCreator.environment()
end

---@param environment number
function Creator:setEnvironment(environment)
    self.worldCreator.environment(World_Environment.getEnvironment(environment))
end

---@return string type
function Creator:getType()
    return self.worldCreator.type()
end

---@param type string
function Creator:setType(type)
    self.worldCreator.type(WorldType.getByName(type))
end

---@return JavaObject|nil generator
function Creator:getGenerator()
    return self.worldCreator.generator()
end

---@param generator JavaObject|nil org.bukkit.generator.ChunkGenerator
function Creator:setGenerator(generator)
    self.worldCreator.generator(generator)
end

---@return JavaObject|nil biomeProvider org.bukkit.generator.BiomeProvider
function Creator:getBiomeProvider()
    return self.worldCreator.biomeProvider()
end

---@param biomeProvider JavaObject|nil org.bukkit.generator.BiomeProvider
function Creator:setBiomeProvider(biomeProvider)
    self.worldCreator.biomeProvider(biomeProvider)
end

---@return string
function Creator:getGeneratorSettings()
    return self.worldCreator.generatorSettings()
end

---@param generatorSettings string
function Creator:setGeneratorSettings(generatorSettings)
    self.worldCreator.generatorSettings(generatorSettings)
end

---@return boolean
function Creator:getGenerateStructures()
    return self.worldCreator.generateStructures()
end

---@param generate boolean
function Creator:setGenerateStructures(generate)
    self.worldCreator.generateStructures(generate)
end

---@return boolean
function Creator:getHardcore()
    return self.worldCreator.hardcore()
end

---@param hardcore boolean
function Creator:setHardcore(hardcore)
    self.worldCreator.hardcore(hardcore)
end

---@return boolean
function Creator:getKeepSpawnInMemory()
    return self.worldCreator.keepSpawnInMemory()
end

---@param keepSpawnInMemory boolean
function Creator:setKeepSpawnInMemory(keepSpawnInMemory)
    self.worldCreator.keepSpawnInMemory(keepSpawnInMemory)
end

---Makes the world a void world
---@return { biome: JavaObject }
function Creator:setupVoid()
    if VoidWorldGenerator == nil then
        local paman = require("@base/paman")
        paman.need("core/classloader")

        local classloader = require("@core/classloader")

        classloader.addClassFile("@worldmanager", "worldmanager_VoidWorldGenerator")
        classloader.addClassFile("@worldmanager", "worldmanager_VoidWorldGenerator$1")

        VoidWorldGenerator = classFor("worldmanager_VoidWorldGenerator")
    end

    local generator = VoidWorldGenerator()
    self:setGenerator(generator)
    return generator
end

---@return JavaObject world org.bukkit.World
function Creator:create()
    return self.worldCreator.createWorld()
end

return Creator
