local classloader = require("@core/classloader")
classloader.addClassFile("app/kvs", "app_KVS")

local KVS = classFor("app_KVS")
local DriverManager = classFor("java.sql.DriverManager")


local kvs = {}

---@param url string
---@return { close: function }
function kvs.createConnection(url)
    return DriverManager.getConnection(url)
end

---@param connection JavaObject
---@param tableName string
---@return pierrelasse.bamboo.kvs.KVS
function kvs.attach(connection, tableName)
    return KVS(connection, tableName)
end

return kvs
