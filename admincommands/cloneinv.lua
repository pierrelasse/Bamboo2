-- TODO

require("@bukkit/getPlayer")


addCommand("cloneinv", function(sender, args)
    if args[1] == nil then
        sender.sendMessage("§cUsage: /cloneinv <to: player> <from: player>")
        return
    end

    local to = bukkit.getPlayerClosest(args[1])
    if to == nil then
        sender.sendMessage("§4From §cnot found!")
        return
    end
    local from = (args[2] ~= nil and bukkit.getPlayer(args[2])) or sender

    sender.sendMessage("§aCloning inventory to §2"..to.getName().."§a from §2"..from.getName())

    to.getInventory().setContents(from.getInventory().getContents())
    to.getInventory().setArmorContents(from.getInventory().getArmorContents())
end)
    .permission("op")
