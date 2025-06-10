local EntityType = import("org.bukkit.entity.EntityType")


---@type table<string, string>
local translations = {}

for entityType in forEach(EntityType.values()) do
    local t = tostring(entityType)
    translations[t] = t
        :lower()
        :gsub("_", " ")
        :gsub(
            "(%a)(%w*)",
            function(first, rest)
                return first:upper()..rest
            end)
end

return translations
