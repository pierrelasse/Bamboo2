local LOCALES = { "de", "en" }


local Player = classFor("org.bukkit.entity.Player")


Bamboo.locales = {}

for _, id in ipairs(LOCALES) do
    Bamboo.locales[id] = require("@pierrelasse/bamboo/lang/locales/"..id)
end

---@param target any
---@return string
function Bamboo.getLocale(target)
    if bukkit.isPlayer(target) then
        return "de"
    end
    return "en"
end

function Bamboo.translate(locale, key)
    local localeData = Bamboo.locales[locale]
    if localeData == nil then
        return locale.."?:"..key
    end
    return localeData[key] or locale..":"..key.."?"
end

function Bamboo.translateF(locale, key, ...)
    local values = { ... }
    local translated = Bamboo.translate(locale, key)
    for i, value in ipairs(values) do
        translated = Bamboo.Helper.stringReplace(translated, "{"..(i - 1).."}", tostring(value))
    end
    return translated
end
