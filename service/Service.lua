---@class app.Service
---@field id string?
---@field enabled boolean = false
---@field tasks table<string, function>|nil
---
---@field meta_type nil|"challenge"|"rule"
---@field meta_name string|nil
---@field meta_material string|nil
---
---@field onLoad fun(path: string)|nil
---@field onSave fun(path: string)|nil
---
---@field onEnable fun()|nil
---@field onDisable fun()|nil
---
---@field onTimer fun(state: boolean)|nil
---
---@field onReset fun()|nil
---
local Service = {}
Service.__index = Service

function Service.new(id)
    local self = setmetatable({}, Service)

    self.id = id

    self.enabled = false

    return self
end

function Service:setEnabled(enabled)
    if self.enabled == enabled then return false end
    if enabled then
        if self.onEnable ~= nil then
            self.onEnable()
        end
        if self.onTimer ~= nil and Timer.isRunning() then
            self.onTimer(true)
        end
    else
        if self.onDisable ~= nil then
            self.onDisable()
        end
        if self.onTimer ~= nil and Timer.isRunning() then
            self.onTimer(false)
        end
    end
    self.enabled = enabled
    return true
end

function Service:doReset()
    self:setEnabled(false)
    if self.onReset ~= nil then
        self.onReset()
    end
end

---@param storage app.util.Storage
---@param path string
function Service:load(storage, path)
    self:setEnabled(storage:get(path..".enabled") == true)
end

---@param storage app.util.Storage
---@param path string
function Service:save(storage, path)
    storage:set(path..".enabled", self.enabled and true or nil)

    storage:clearIfEmpty(path)
end

---@param id string
---@param handler fun(sender: JavaObject, args: string[])
function Service:addTask(id, handler)
    if self.tasks == nil then self.tasks = {} end
    self.tasks[id] = handler
end

return Service
