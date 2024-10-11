require("@bukkit/index")


bukkit.version = {
    VERSION = {}
}

---@private
function bukkit.version.init()
    local str = bukkit.Bukkit.getBukkitVersion()
    local version = string.sub(str, 0, string.find(str, "-") - 1)
    local parts = string.split(version, ".")

    local i = 0
    for _, part in ipairs(parts) do
        local num = tonumber(part)
        if num ~= nil then
            i = i + 1
            bukkit.version.VERSION[i] = num
        end
    end
end

bukkit.version.init()

---@param major number
---@param minor number
---@param patch number
---@return boolean
function bukkit.version.before(major, minor, patch)
    if bukkit.version.VERSION[1] < major then
        return true
    elseif bukkit.version.VERSION[1] == major then
        if bukkit.version.VERSION[2] < minor then
            return true
        elseif bukkit.version.VERSION[2] == minor and bukkit.version.VERSION[3] < patch then
            return true
        end
    end
    return false
end

---@param major number
---@param minor number
---@param patch number
---@return boolean
function bukkit.version.is(major, minor, patch)
    return bukkit.version.VERSION[1] == major and bukkit.version.VERSION[2] == minor and
        bukkit.version.VERSION[3] == patch
end

---@param major number
---@param minor number
---@param patch number
---@return boolean
function bukkit.version.after(major, minor, patch)
    if bukkit.version.VERSION[1] > major then
        return true
    elseif bukkit.version.VERSION[1] == major then
        if bukkit.version.VERSION[2] > minor then
            return true
        elseif bukkit.version.VERSION[2] == minor and bukkit.version.VERSION[3] > patch then
            return true
        end
    end
    return false
end

---@deprecated
bukkit.version.isBefore = bukkit.version.before
---@deprecated
bukkit.version.isAfter = bukkit.version.after

return bukkit.version
