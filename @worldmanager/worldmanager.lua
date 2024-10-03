local Bukkit = classFor("org.bukkit.Bukkit")

local fs = require("@base/fs")
local Creator = require("@worldmanager/Creator")


local worldmanager = {
    Creator = Creator
}

---
---@param name string
---@return JavaObject world org.bukkit.World
function worldmanager.get(name)
    return Bukkit.getWorld(name)
end

---
---@param name string
---@return boolean
function worldmanager.has(name)
    return worldmanager.get(name) ~= nil
end

---
---@param name string
---@return worldmanager.Creator
function worldmanager.create(name)
    return Creator.new(name)
end

---
---@param name string
---@param save boolean
---@return boolean success
function worldmanager.unload(name, save)
    return Bukkit.unloadWorld(name, save)
end

---
---@param world JavaObject org.bukkit.World
---@param save boolean
---@return boolean success
function worldmanager.unloadWorld(world, save)
    return Bukkit.unloadWorld(world, save)
end

---
---@param name string
---@return boolean success
function worldmanager.delete(name)
    local world = worldmanager.get(name)
    if world == nil then return true end
    return worldmanager.unloadWorld(world, false) and fs.remove(world.getWorldFolder())
end

return worldmanager
