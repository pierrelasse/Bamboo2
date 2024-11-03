addCommand("timer", function(sender, args)
    if args[1] == "continue" then
        Bamboo.timer.start()
        bukkit.send(sender, Bamboo.translate(
            Bamboo.getLocale(sender), "timer.command.start"))
    elseif args[1] == "terminate" then
        Bamboo.timer.stop()
        bukkit.send(sender, Bamboo.translate(
            Bamboo.getLocale(sender), "timer.command.stop"))
    elseif args[1] == "delete" then
        Bamboo.timer.reset()
        bukkit.send(sender, Bamboo.translate(
            Bamboo.getLocale(sender), "timer.command.reset"))
    else
        bukkit.send(sender, Bamboo.translate(
            Bamboo.getLocale(sender), "timer.command.usage"))
    end
end).complete(function(completions, sender, args)
    completions.add("continue")
    completions.add("terminate")
    completions.add("delete")
end).permission("op")
