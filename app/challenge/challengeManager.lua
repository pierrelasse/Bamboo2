local CHALLENGE_IDS = {
    "blockdroprandomizer"
}

local ScriptStoppingEvent = classFor("net.bluept.scripting.ScriptStoppingEvent")

local Challenge = require("app/challenge/Challenge")


local challengeManager = {
    ---@type table<string, app.challenge.Challenge>
    challenges = {}
}

function challengeManager.loadChallenges()
    for _, id in ipairs(CHALLENGE_IDS) do
        ---@type app.challenge.Challenge
        local challenge = Challenge.new(id)
        require("app/challenges/"..id.."/index")(challenge)
        challenge:setEnabled(true)
        challengeManager.challenges[id] = challenge
    end
end

addEvent(ScriptStoppingEvent, function()
    for _, challenge in pairs(challengeManager.challenges) do
        challenge:setEnabled(false)
    end
end)

return challengeManager
