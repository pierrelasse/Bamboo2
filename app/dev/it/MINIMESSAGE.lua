return function(player, args)
    player.sendMessage(ToMiniMessage(table.concat(args, " ", 1)))
end
