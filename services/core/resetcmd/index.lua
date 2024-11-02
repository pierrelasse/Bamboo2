---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---@type ScriptCommand
    local cmd

    service.onEnable = function()
        if cmd == nil then
            cmd = addCommand("reset", function(sender, args)
                if args[1] == "confirm" then
                    Send(sender, "§lDie Welten werden zurückgesetzt.")
                    FastReset(sender)
                else
                    Send(sender, "§cFalsche Verwendung!")
                end
            end).complete(function(completions, sender, args)
                completions.add("confirm")
            end).permission("op")
        else
            cmd.register()
        end
    end

    service.onDisable = function()
        cmd.unregister()
    end
end
