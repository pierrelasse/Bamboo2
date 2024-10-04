---@class app.challenge.Challenge
---@field id string?
---@field enabled boolean = false
---@field events ScriptEvent[]|nil
---
---@field onLoad fun(path: string)|nil
---@field onSave fun(path: string)|nil
---
---@field onEnable fun()|nil
---@field onDisable fun()|nil
---
---@field onReset fun()|nil
---
local Challenge = {}
Challenge.__index = Challenge

function Challenge.new(id)
    local self = setmetatable({}, Challenge)

    self.id = id

    self.enabled = false

    return self
end

function Challenge:registerEvents()
    if self.events == nil then return end
    for _, event in ipairs(self.events) do
        event.register()
    end
end

function Challenge:unregisterEvents()
    if self.events == nil then return end
    for _, event in ipairs(self.events) do
        event.unregister()
    end
end

function Challenge:setEnabled(enabled)
    if self.enabled == enabled then return false end
    if enabled then
        if self.onEnable ~= nil then
            self.onEnable()
        end
        self:registerEvents()
    else
        if self.onDisable ~= nil then
            self.onDisable()
        end
        self:unregisterEvents()
    end
    self.enabled = enabled
    return true
end

function Challenge:doReset()
    self:setEnabled(false)
    if self.onReset ~= nil then
        self.onReset()
    end
end

---@param storage app.util.Storage
---@param path string
function Challenge:load(storage, path)
    self:setEnabled(storage:get(path..".enabled") == true)
end

---@param storage app.util.Storage
---@param path string
function Challenge:save(storage, path)
    storage:set(path..".enabled", self.enabled and true or nil)

    storage:clearIfEmpty(path)
end

---@generic T : JavaObject
---@param eventClass T The class of the event.
---@param handler fun(event: T) The event handler.
function Challenge:addEvent(eventClass, handler)
    if self.events == nil then
        self.events = {}
    end
    self.events[#self.events + 1] =
        addEvent(eventClass, handler, false)
end

return Challenge
