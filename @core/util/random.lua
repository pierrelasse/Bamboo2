local random = {
    ---@type JavaObject
    instance = nil
}

function random:getRandom()
    if self.instance == nil then
        self.instance = classFor("java.util.Random")()
    end
    return self.instance
end

---Generates a random integer within the specified range.
---@param min number The minimum value (inclusive).
---@param max number The maximum value (inclusive).
---@return number Random integer between min and max.
function random:randInt(min, max)
    return self:getRandom().nextInt(max - min + 1) + min
end

---Generates a random floating-point number within the specified range.
---@param min number The minimum value (inclusive).
---@param max number The maximum value (exclusive).
---@return number Random floating-point number between min and max.
function random:randFloat(min, max)
    return self:getRandom().nextFloat() * (max - min) + min
end

---Generates a random boolean.
---@return boolean Random boolean.
function random:randBool()
    return self:getRandom().nextBoolean()
end

function random:chance(chance)
    return self:randInt(1, 100) <= chance
end

return random
