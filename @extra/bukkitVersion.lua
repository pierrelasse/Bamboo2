local Bukkit = classFor("org.bukkit.Bukkit")


local bukkitVersion = {}

function bukkitVersion.init()
    local s = Bukkit.getBukkitVersion()
    local version = string.sub(s, 0, string.find(s, "-") - 1)
    local versionParts = string.split(version, ".")

    local parts = {}
    for _, part in ipairs(versionParts) do
        local num = tonumber(part)
        if num ~= nil then
            parts[#parts + 1] = num
        end
    end

    bukkitVersion.VERSION = parts
end

bukkitVersion.init()

function bukkitVersion.isBefore(major, minor, patch)
    if bukkitVersion.VERSION[1] < major then
        return true
    elseif bukkitVersion.VERSION[1] == major then
        if bukkitVersion.VERSION[2] < minor then
            return true
        elseif bukkitVersion.VERSION[2] == minor and bukkitVersion.VERSION[3] < patch then
            return true
        end
    end
    return false
end

function bukkitVersion.is(major, minor, patch)
    return bukkitVersion.VERSION[1] == major and bukkitVersion.VERSION[2] == minor and bukkitVersion.VERSION[3] == patch
end

function bukkitVersion.isAfter(major, minor, patch)
    if bukkitVersion.VERSION[1] > major then
        return true
    elseif bukkitVersion.VERSION[1] == major then
        if bukkitVersion.VERSION[2] > minor then
            return true
        elseif bukkitVersion.VERSION[2] == minor and bukkitVersion.VERSION[3] > patch then
            return true
        end
    end
    return false
end

return bukkitVersion
