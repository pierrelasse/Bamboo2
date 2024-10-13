return function(player)
    local name = player.getName()
    local cmd

    cmd = addCommand("dyncommand", function(sender, args)
        sender.sendMessage("created by: "..name)
        cmd.unregister()
    end)
end
