local timer = require("app/sys/timer")


addCommand("timer", function(sender, args)
    if args[1] == "continue" then
        timer.start()
        Send(sender, I18n.g("timer", "command.continue"))
    elseif args[1] == "terminate" then
        timer.stop()
        Send(sender, I18n.g("timer", "command.terminate"))
    elseif args[1] == "delete" then
        timer.reset()
        Send(sender, I18n.g("timer", "command.delete"))
    else
        Send(sender, I18n.g("timer", "command.usage"))
    end
end).complete(function(completions, sender, args)
    completions.add("continue")
    completions.add("terminate")
    completions.add("delete")
end).permission("op")
