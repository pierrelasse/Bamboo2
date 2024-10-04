local CHALLENGE_IDS = {
    "blockdroprandomizer"
}

local Storage = require("app/util/Storage")
local Challenge = require("app/challenge/Challenge")


local challengeManager = {
    ---@type table<string, app.challenge.Challenge>
    challenges = {},

    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenOverworld = nil,
    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenNether = nil,
    ---@type JavaObject|nil org.bukkit.generator.ChunkGenerator
    worldGenEnd = nil,
}

local storage = Storage.new("challenges")
storage:loadSave(function()
    for id, challenge in pairs(challengeManager.challenges) do
        challenge:save(storage, "challenges."..id)
    end
    storage:clearIfEmpty("challenges")
end)

function challengeManager.loadChallenges()
    for _, id in ipairs(CHALLENGE_IDS) do
        ---@type app.challenge.Challenge
        local challenge = Challenge.new(id)
        require("app/challenges/"..id.."/index")(challenge)
        challenge:load(storage, "challenges."..id)
        challengeManager.challenges[id] = challenge
    end
end

return challengeManager
