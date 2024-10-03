if table.length == nil then
    function table.length(list)
        if type(list) == "table" then
            local length = 0
            for _ in pairs(list) do
                length = length + 1
            end
            return length
        end
    end
end

---
---@param list table
---@return any value
---@return any key
function table.first(list)
    for k, v in pairs(list) do
        return v, k
    end
end

function table.unpck(list, endIndex, startIndex)
    startIndex = startIndex or 1
    endIndex = endIndex or #list
    if startIndex <= endIndex then
        return list[startIndex], table.unpck(list, endIndex, startIndex + 1)
    end
end

function table.randomElement(list)
    return list[math.random(#list)]
end

---
---@param list table
---@param from number
---@param to number
---@param with any
---@param step? number 1 by default
function table.fill(list, from, to, with, step)
    for i = from, to, (step or 1) do
        list[i] = with
    end
end

function table.key(list, value, default)
    if value ~= nil and type(list) == "table" then
        for k, v in pairs(list) do
            if v == value then
                return k
            end
        end
    end
    return default
end

function table.copy(element)
    if type(element) == "table" then
        local newTable = {}
        for k, v in pairs(element) do
            newTable[k] = v
        end
        return newTable
    else
        return element
    end
end

function table.removeValue(list, value)
    for k, v in pairs(list) do
        if v == value then
            list[k] = nil
        end
    end
end

table.join = table.concat

function table.shuffle(list)
    local length = #list
    for i = length, 2, -1 do
        local j = math.random(1, i)
        list[i], list[j] = list[j], list[i]
    end
end

function table.keys(list)
    local keys = {}
    for key, _ in pairs(list) do
        keys[#keys + 1] = key
    end
    return keys
end
