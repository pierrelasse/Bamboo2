local challengeManager = require("app/challenge/challengeManager")


addCommand("challenges", function(sender, args)
    if #args == 0 then
        sender.sendMessage("Challenges: "..table.concat(table.keys(challengeManager.challenges), ", "))
        return
    end

    local challenge = challengeManager.challenges[args[1]]
    if challenge == nil then
        sender.sendMessage("§cNicht gefunden")
        return
    end

    local action = args[2]
    if action == nil then
        local msg = "§l"..challenge.id.."§8:"
        msg = msg.."\n §7Status: "..(challenge.enabled and "§aAktiv" or "§cInaktiv")
        sender.sendMessage(msg)
        return
    end

    if action == "enable" then
        if challenge:setEnabled(true) then
            sender.sendMessage("§2"..challenge.id.."§a aktiviert")
        end
        return
    end

    if action == "disable" then
        if challenge:setEnabled(false) then
            sender.sendMessage("§2"..challenge.id.."§a deaktiviert")
        end
        return
    end

    if action == "reset" then
        challenge:doReset()
        sender.sendMessage("§2"..challenge.id.."§a zurückgesetzt")
        return
    end

    if string.startswith(action, ":") then
        local handler
        if challenge.tasks ~= nil then
            local id = string.sub(action, 2)
            handler = challenge.tasks[id]
        end
        if handler == nil then
            sender.sendMessage("§cTask nicht gefunden")
            return
        end
        handler(sender, args)
        return
    end

    sender.sendMessage("§cAktion nicht gefunden")
end).permission("op")
    .complete(function(completions, sender, args)
        if #args == 1 then
            for key, _ in pairs(challengeManager.challenges) do
                completions.add(key)
            end
        elseif #args == 2 then
            completions.add("enable")
            completions.add("disable")
            completions.add("reset")

            local challengeId = args[1]
            local challenge = challengeManager.challenges[challengeId]
            if challenge == nil or challenge.tasks == nil then return end
            for id, _ in pairs(challenge.tasks) do
                completions.add(":"..id)
            end
        end
    end)
