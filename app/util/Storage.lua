local ScriptStoppingEvent = classFor("net.bluept.scripting.ScriptStoppingEvent")
local ArrayList = classFor("java.util.ArrayList")
local YamlConfiguration = classFor("org.bukkit.configuration.file.YamlConfiguration")

local fs = require("@base/fs")
local logger = require("app/util/logger").new("Storage")


---@class app.util.Storage
---@field name string
---@field file JavaObject java.io.File
---@field config JavaObject
---@field saveCb fun()|nil
local Storage = {}
Storage.__index = Storage

function Storage.new(name)
    local self = setmetatable({}, Storage)

    self.name = name

    local dir = fs.file(fs.scriptingDir(), "../scripting.storage/")
    dir.mkdirs()
    self.file = fs.file(dir, "app-"..name..".yml")

    self.config = YamlConfiguration()

    return self
end

function Storage:load()
    if self.file.isFile() then
        self.config.load(self.file)
    end
end

function Storage:save()
    if self.saveCb ~= nil then self.saveCb() end

    if self.file.isFile() or not self.file.exists() then
        self.config.save(self.file)
    end
end

function Storage:loadSave(saveCb)
    logger:debug("loading '"..self.name.."'")
    self:load()
    self.saveCb = saveCb
    addEvent(ScriptStoppingEvent, function()
        logger:debug("saving '"..self.name.."'")
        self:save()
    end)
end

function Storage:has(path)
    return self.config.isSet(path) == true
end

function Storage:get(path, def)
    if def == nil then
        return self.config.get(path)
    else
        return self.config.get(path, def)
    end
end

function Storage:set(path, value)
    self.config.set(path, value)
end

function Storage:getList(path)
    local list = self.config.getList(path)
    if list == nil then
        list = ArrayList()
        self.config.set(path, list)
    end
    return list
end

function Storage:getKeys(path)
    local section = self.config.getConfigurationSection(path)
    if section ~= nil then
        return section.getKeys(false)
    end
end

function Storage:getValues(path)
    local section = self.config.getConfigurationSection(path)
    if section ~= nil then
        return section.getValues(false)
    end
end

function Storage:clearIfEmpty(path)
    local keys = self:getKeys(path)
    if keys ~= nil and keys.size() == 0 then
        self:set(path, nil)
    end
end

return Storage
