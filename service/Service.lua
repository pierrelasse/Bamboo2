---@class pierrelasse.bamboo.Service
---@field id string?
---@field enabled boolean = false
---@field tasks table<string, function>|nil
---@field events ScriptEvent[]?
---@field exports any
---
---@field enabledByDefault true?
---@field meta_type nil|"challenge"|"rule"|"core"
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
        if self.onTimer ~= nil and Bamboo.timer.isRunning() then
            self.onTimer(true)
        end
        self:registerEvents()
    else
        self:unregisterEvents()
        if self.onTimer ~= nil and Bamboo.timer.isRunning() then
            self.onTimer(false)
        end
        if self.onDisable ~= nil then
            self.onDisable()
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

---@param storage pierrelasse.bamboo.util.Storage
---@param path string
function Service:load(storage, path)
    local enabled = storage:get(path..".enabled")
    if enabled == nil then
        enabled = self.enabledByDefault == true
    else
        enabled = enabled == true
    end
    self:setEnabled(enabled)
end

---@param storage pierrelasse.bamboo.util.Storage
---@param path string
function Service:save(storage, path)
    local savedState
    if self.enabled == self.enabledByDefault then
        savedState = nil
    else
        savedState = self.enabled
    end
    storage:set(path..".enabled", savedState)

    storage:clearIfEmpty(path)
end

---@param id string
---@param handler fun(sender: JavaObject, args: string[])
function Service:task(id, handler)
    if self.tasks == nil then self.tasks = {} end
    self.tasks[id] = handler
end

function Service:registerEvents()
    if self.events == nil then return end
    for _, event in ipairs(self.events) do
        event.register()
    end
end

function Service:unregisterEvents()
    if self.events == nil then return end
    for _, event in ipairs(self.events) do
        event.unregister()
    end
end

---@param eventClass JavaClass
---@param handler fun(event: JavaObject)
---@return ScriptEvent
function Service:event(eventClass, handler)
    if self.events == nil then self.events = {} end

    local event = addEvent(eventClass, handler, self.enabled)
    self.events[#self.events + 1] = event

    return event
end

function Service:logger()
    return Bamboo.logger("srv:"..self.id)
end

return Service
