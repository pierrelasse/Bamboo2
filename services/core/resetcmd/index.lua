---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    addCommand("reset", function(sender, args)
        if args[1] == "confirm" then
            Send(sender, "§lDie Welten werden zurückgesetzt.")
            FastReset(sender)
        else
            Send(sender, "§cFalsche Verwendung!")
        end
    end).complete(function(completions, sender, args)
        completions.add("confirm")
    end).permission("op")
end
