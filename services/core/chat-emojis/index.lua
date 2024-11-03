local specialChars = require("@pierrelasse/bamboo/util/specialChars")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    function service.exports(input)
        input = string.replace(input, ":skull:", "💀")
        input = string.replace(input, ":sus:", "ඞ")
        input = string.replace(input, ":peepohey:", specialChars.emoji_peepohey)
        input = string.replace(input, ":schneemann:", specialChars.emoji_snowman)

        return input
    end
end
