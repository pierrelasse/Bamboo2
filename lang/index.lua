local LOCALES = { "de", "en" }


Bamboo.locales = {}

for _, id in ipairs(LOCALES) do
    Bamboo.locales[id] = require("@pierrelasse/bamboo/lang/locales/"..id)
end


function Bamboo.translate(sender, key)
end
