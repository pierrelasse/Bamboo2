local it = {
    "BLOCK_GRIEF",
    "CHANGE_NAME_SUSSY",
    "CONVERSATION_WTF",
    "DISPLAYFUNNYTITLE",
    "DYNCMD",
    "MATHE_INPUT",
    "FUNNY_FLYING_TNT",
    "MINIMESSAGE",
    "MULTI_ASYNC",
    "NAMETAGS",
    "RAINBOW_SB",
    "RAYTRACE_COOL",
    "RGB_PLAYER_LIST_NAME",
    "SB_REVIEW",
    "SOUNDCHECK",
    "SPIGOT_SEND",
    "SQL",
    "SYSTEMMSG",
    "TENGOKU",
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

        it[id] = require("@pierrelasse/bamboo/dev/it/"..id)
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
                local text
                if type(k) == "string" then
                    text = k
                else
                    text = v
                end
                if args[1] == nil or string.startswith(text, args[1]) then
                    completions.add(text)
                end
            end
        end
    end)
