I18n = {
    map = {}
}

---@param namespace string
---@param translations table<string, string>
function I18n.register(namespace, translations)
    if I18n.map[namespace] == nil then
        I18n.map[namespace] = translations
    end
end

function I18n.f(namespace, key, ...)
    local trans = I18n.g(namespace, key)
    for i, value in ipairs({ ... }) do
        trans = string.replace(trans, "{"..(i - 1).."}", tostring(value))
    end
    return trans
end

function I18n.g(namespace, key)
    local ns = I18n.map[namespace]
    if ns == nil then return namespace.."?:"..key end

    local trans = ns[key]
    if trans == nil then return namespace..":"..key.."?" end

    return trans
end
