addCommand("service", function(sender, args)
    if #args == 0 then
        -- TODO
        sender.sendMessage("§7Services: "..table.concat(table.keys(Bamboo.serviceManager.entries), ", "))
        return
    end

    local service = Bamboo.serviceManager.entries[args[1]]
    if service == nil then
        sender.sendMessage("§cService not found")
        return
    end

    local action = args[2]
    if action == nil then
        local msg = "§l"..service.id.."§8:"
        msg = msg.."\n §7Status: "..(service.enabled and "§aActive" or "§cInactive")
        sender.sendMessage(msg)
        return
    end

    if action == "enable" then
        if service:setEnabled(true) then
            sender.sendMessage("§2"..service.id.."§a enabled")
        end
        return
    end

    if action == "disable" then
        if service:setEnabled(false) then
            sender.sendMessage("§2"..service.id.."§a disabled")
        end
        return
    end

    if action == "reset" then
        service:doReset()
        sender.sendMessage("§2"..service.id.."§a resetted")
        return
    end

    if string.startswith(action, ":") then
        local handler
        if service.tasks ~= nil then
            local id = string.sub(action, 2)
            handler = service.tasks[id]
        end
        if handler == nil then
            sender.sendMessage("§cTask not found")
            return
        end
        handler(sender, args)
        return
    end

    sender.sendMessage("§cAction not found")
end).permission("op")
    .complete(function(completions, sender, args)
        local function complete(value, i)
            if args[i] == nil or string.startswith(value, args[i]) then
                completions.add(value)
            end
        end

        if #args == 1 then
            for key, _ in pairs(Bamboo.serviceManager.entries) do
                complete(key, 1)
            end
        elseif #args == 2 then
            if string.at(args[2], 1) == ":" then
                local id = args[1]
                local service = Bamboo.serviceManager.entries[id]
                if service == nil or service.tasks == nil then return end
                for taskId, _ in pairs(service.tasks) do
                    complete(":"..taskId)
                end
            else
                complete(":", 2)
                complete("enable", 2)
                complete("disable", 2)
                complete("reset", 2)
            end
        end
    end)
