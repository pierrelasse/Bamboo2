local PERMISSION_COMMAND = "admin.clearchat"
local PERMISSION_BYPASS = "admin.clearchat.bypass"
local MESSAGE_CLEARED = "§7Chat cleared by §e%s§7!"

require("@bukkit/send")
require("@bukkit/onlinePlayers")


addCommand("clearchat", function(sender, args)
    local clearingMessage = ""
    for _ = 0, 100 do
        clearingMessage = clearingMessage.."§\n"
    end
    clearingMessage = clearingMessage.."§"

    local clearedMessage = string.format(MESSAGE_CLEARED, sender.getName())

    for player in bukkit.onlinePlayersLoop() do
        if not player.hasPermission(PERMISSION_BYPASS) then
            player.sendMessage(clearingMessage)
        end
        bukkit.send(player, clearedMessage)
    end
end)
    .permission(PERMISSION_COMMAND)
