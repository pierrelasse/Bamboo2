---@class app.challenge.Challenge
---@field id string?
---@field enabled boolean = false
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

function Challenge:setEnabled(enabled)
    if self.enabled == enabled then return false end
    if enabled then
        if self.onEnable ~= nil then
            self.onEnable()
        end
    else
        if self.onDisable ~= nil then
            self.onDisable()
        end
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

return Challenge
