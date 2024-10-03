local CHALLENGE_IDS = {
    "blockdroprandomizer"
}

local Challenge = require("app/challenge/Challenge")


local challengeManager = {
    ---@type table<string, app.challenge.Challenge>
    challenges = {}
}

function challengeManager.loadChallenges()
    for _, id in ipairs(CHALLENGE_IDS) do
        ---@type app.challenge.Challenge
        local challenge = Challenge.new(id, true)
        require("app/challenges/"..id.."/index")(challenge)
        challengeManager.challenges[id] = challenge
    end
end

return challengeManager
