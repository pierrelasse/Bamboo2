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

    local msg = "§l"..challenge.id.."§8:"
    msg = msg.."\n §7Status: "..(challenge.enabled and "§aAktiv" or "§cInaktiv")
    sender.sendMessage(msg)
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
        end
    end)
