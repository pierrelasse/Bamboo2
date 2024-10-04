local classloader = require("@core/classloader")

classloader.addClassFile("app/challenges/dev-worldgen", "app_challenges_dev_worldgen_Generator")
local Generator = classFor("app_challenges_dev_worldgen_Generator")


---@param challenge app.challenge.Challenge
return function(challenge)
    challenge.meta_material = "GRASS_BLOCK"
end
