I18n.register("reset", {
    ["command.reset"] = "§lDie Welten werden zurückgesetzt.",
    ["command.usage"] = "§cFalsche Verwendung!"
})


addCommand("reset", function(sender, args)
    if args[1] == "confirm" then
        Send(sender, I18n.g("reset", "command.reset"))
        FastReset(sender)
    else
        Send(sender, I18n.g("reset", "command.usage"))
    end
end).complete(function(completions, sender, args)
    completions.add("confirm")
end).permission("op")
