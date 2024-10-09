local IDS = {
    "challenges/bba",
    "challenges/blockdroprandomizer",
    "challenges/minecraftaberalle30sekundenkommentntminecarts",
}

local Storage = require("app/util/Storage")
local Service = require("app/service/Service")


local serviceManager = {
    ---@type table<string, app.Service>
    entries = {},

    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenOverworld = nil,
    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenNether = nil,
    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenEnd = nil,
}

local storage = Storage.new("services")
storage:loadSave(function()
    for id, service in pairs(serviceManager.entries) do
        service:save(storage, "services."..id)
    end
    storage:clearIfEmpty("services")
end)

function serviceManager.load()
    for _, id in ipairs(IDS) do
        ---@type app.Service
        local service = Service.new(id)
        require("app/services/"..id.."/index")(service)
        service:load(storage, "services."..id)
        serviceManager.entries[id] = service
    end
end

return serviceManager
