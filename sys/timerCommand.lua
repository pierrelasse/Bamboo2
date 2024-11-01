addCommand("timer", function(sender, args)
    if args[1] == "continue" then
        Bamboo.timer.start()
        Send(sender, "§lDer Timer wird nun fortgesetzt.")
    elseif args[1] == "terminate" then
        Bamboo.timer.stop()
        Send(sender, "§lDer Timer wird nun pausiert.")
    elseif args[1] == "delete" then
        Bamboo.timer.reset()
        Send(sender, "§lDer Timer wird nun zurückgesetzt.")
    else
        Send(sender, "§cFalsche Verwendung!")
    end
end).complete(function(completions, sender, args)
    completions.add("continue")
    completions.add("terminate")
    completions.add("delete")
end).permission("op")
