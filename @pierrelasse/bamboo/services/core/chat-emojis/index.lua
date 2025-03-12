local specialChars = require("@pierrelasse/bamboo/util/specialChars")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    function service.exports(input)
        input = Bamboo.Helper.stringReplace(input, ":skull:", "💀")
        input = Bamboo.Helper.stringReplace(input, ":sus:", "ඞ")
        input = Bamboo.Helper.stringReplace(input, ":peepohey:", specialChars.emoji_peepohey)
        input = Bamboo.Helper.stringReplace(input, ":schneemann:", specialChars.emoji_snowman)

        return input
    end
end
