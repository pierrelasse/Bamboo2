local it = {
    "BLOCK_GRIEF",
    "CONVERSATION_WTF",
    "DISPLAYFUNNYTITLE",
    "DYNCMD",
    "FUNNY_FLYING_TNT",
    "MINIMESSAGE",
    "MULTI_ASYNC",
    "SOUNDCHECK",
    "SPIGOT_SEND",
    "SYSTEMMSG",
}

addCommand("dev", function(sender, args)
    local id = args[1]
    if id == nil then
        sender.sendMessage "§cUsage: /dev <id>"
        return
    end

    local cb = it[id]
    if cb == nil then
        local i = table.key(it, id)
        if i == nil then
            sender.sendMessage "§cNot found"
            return
        end

        it[id] = require("app/dev/it/"..id)
        it[i] = nil
    end

    cb = it[id]
    if type(cb) ~= "function" then
        sender.sendMessage "§cNot executable"
        return
    end

    cb(sender, args)
end).permission "op"
    .complete(function(completions, sender, args)
        if #args == 1 then
            for k, v in pairs(it) do
                if type(k) == "string" then
                    completions.add(k)
                else
                    completions.add(v)
                end
            end
        end
    end)
