---@param slots integer[]
---@param page integer
---@param filter fun(service: pierrelasse.bamboo.Service):boolean
---@param setter fun(slot: integer, service: pierrelasse.bamboo.Service|nil)
---@return integer maxPages
return function(slots, page, filter, setter)
    local ids = {}
    for serviceId, service in pairs(Bamboo.serviceManager.entries) do
        if filter(service) then
            ids[#ids + 1] = serviceId
        end
    end

    local currId = 1 + (#slots * (page - 1))

    for offset = 0, #slots - 1 do
        local slot = 2 + offset
        local idIndex = currId + offset
        local serviceId = ids[idIndex]
        setter(slot, serviceId == nil and nil or Bamboo.serviceManager.entries[serviceId])
    end

    return table.length(ids) / #slots
end
