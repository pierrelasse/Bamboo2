local AsyncPlayerChatEvent = classFor("org.bukkit.event.player.AsyncPlayerChatEvent")


---@class pierrelasse.bamboo.util.chatInput.Id: string

---@class pierrelasse.bamboo.util.chatInput.Data
---@field timeout integer? in ticks
---@field accept fun(message: string):true?
---@field cancel fun(reason: "timeout"|"custom"|string)?
---
---@field timeout_task ScriptTask?


local chatInput = {
    ---@type table<pierrelasse.bamboo.util.chatInput.Id, pierrelasse.bamboo.util.chatInput.Data>
    queries = {}
}

---@param player JavaObject
---@return pierrelasse.bamboo.util.chatInput.Id
function chatInput.getId(player)
    return player.getUniqueId().toString()
end

function chatInput.hasActive(id)
    return chatInput.queries[id] ~= nil
end

---@param player JavaObject org.bukkit.entity.Player
---@param data pierrelasse.bamboo.util.chatInput.Data
---@return pierrelasse.bamboo.util.chatInput.Id? id
function chatInput.exec(player, data)
    local id = chatInput.getId(player)
    if chatInput.hasActive(id) then return end
    chatInput.queries[id] = data

    if data.timeout ~= nil then
        data.timeout_task = wait(data.timeout, function()
            chatInput.cancel(id, "timeout")
        end)
    end

    return id
end

function chatInput.delete(id)
    local data = chatInput.queries[id]
    if data == nil then return end
    if data.timeout_task ~= nil then
        data.timeout_task.cancel()
    end
    chatInput.queries[id] = nil
end

---@param id pierrelasse.bamboo.util.chatInput.Id
---@param reason string?
function chatInput.cancel(id, reason)
    if chatInput.queries[id] == nil then return end
    chatInput.queries[id].cancel(reason or "custom")
    chatInput.delete(id)
end

addEvent(AsyncPlayerChatEvent, function(event)
    local player = event.getPlayer()
    local id = chatInput.getId(player)
    local data = chatInput.queries[id]
    if data == nil then return end

    event.setCancelled(true)

    local message = event.getMessage()

    if data.accept(message) == true then
        chatInput.delete(id)
    end
end)
    .priority("LOW")

return chatInput
