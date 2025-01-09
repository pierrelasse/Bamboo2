local IDS = {
    "challenges/bba",
    "challenges/blockdroprandomizer",
    "challenges/minecraftaberalle30sekundenkommentntminecarts",

    "core/chat",
    "core/chat-emojis",
    "core/joinquitmsgs",
    "core/menu",
    "core/messaging",
    "core/motd",
    "core/ranks",
    "core/resetcmd",
    "core/resources",
    "core/timerDisplay",

    "rules/timer_no_interact",
}

local Storage = require("@pierrelasse/bamboo/util/Storage")
local Service = require("@pierrelasse/bamboo/service/Service")


local serviceManager = {
    ---@type table<string, pierrelasse.bamboo.Service>
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
        ---@type pierrelasse.bamboo.Service
        local service = Service.new(id)
        require("@pierrelasse/bamboo/services/"..id.."/index")(service)
        service:load(storage, "services."..id)
        serviceManager.entries[id] = service
    end
end

function serviceManager.get(id)
    local service = serviceManager.entries[id]
    if service ~= nil and service.enabled == true then
        return service.exports
    end
end

Bamboo.serviceManager = serviceManager
