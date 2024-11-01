---@meta

---@class pierrelasse.bamboo.kvs.KVS
local KVS = {}

---Get data from remote.
function KVS.pull() end

---Pulls and updates the data on remote.
function KVS.push() end

---Return value or nil for key.
---@param key string
---@return string?
function KVS.get(key) end

---Returns all keys with a given prefix.
---@param prefix string
---@return {get: function, size: function}
function KVS.getPrefixed(prefix) end

---Sets the value of key to value.
---@param key string
---@param value string|nil
function KVS.set(key, value) end

---Deletes a key.
---@param key string
function KVS.delete(key) end
