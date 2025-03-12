local time = require("@core/util/time")
local sql  = require("@extra/sql/sql")

local conn = sql.connect("jdbc:sqlite:bluept/scripting.storage/test.db")

conn.update(
    "CREATE TABLE IF NOT EXISTS users ("..
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"..
    "name TEXT NOT NULL)"
)
conn.update(
    "CREATE TABLE IF NOT EXISTS balance ("..
    "id INTEGER PRIMARY KEY,"..
    "balance INTEGER NOT NULL)"
)

addCommand("setbalance", function(sender, args)
    local name = args[1]
    local balance = tonumber(args[2])
    if balance == nil then return end

    local rs = sql.builder()
        :select("id")
        :from("users")
        :where("name = ?", name)
        :runQuery(conn)

    local userId
    if rs.next() then
        userId = rs.getInt("id")
    else
        sql.builder()
            :insertInto("users", "name")
            :values(name)
            :runUpdate(conn)

        rs = sql.builder()
            :select("id")
            :from("users")
            :where("name = ?", name)
            :runQuery(conn)

        if rs.next() then
            userId = rs.getInt("id")
        else
            sender.sendMessage("§cuser error")
            return
        end
    end

    conn.update(
        "INSERT INTO balance (id, balance) VALUES (?, ?) ON CONFLICT(id) DO UPDATE SET balance = ?",
        { userId, balance, balance }
    )
end)

addCommand("getbalance", function(sender, args)
    local name = args[1]
    if name == nil then return end

    local rs = conn.query(
        "SELECT u.id, b.balance FROM users u LEFT JOIN balance b ON u.id = b.id WHERE u.name = ?",
        { name }
    )
    if rs.next() then
        local balance = rs.getInt("balance")
        sender.sendMessage("§7Balance: §e"..balance)
    else
        sender.sendMessage("§cUser not found")
    end
end)


return function()
    local startTime = time.currentMs()

    local rs = sql.builder()
        :select("*")
        :from("users")
        :runQuery(conn)

    local metaData = rs.getMetaData()
    local columnCount = metaData.getColumnCount()

    print("")
    print("=================")
    while rs.next() do
        local id = rs.getInt(1)
        local name = rs.getString(2)
        print("#"..id.." | name='"..name.."'")
    end
    print("=================")
    print("")

    print("query took "..(time.currentMs() - startTime).." ms!")
end
