local PERMISSION_COMMAND = "admin.sudo.command"
local MESSAGE_TARGET_NOT_FOUND = "§cTarget not found!"
local MESSAGE_SUDOING = "§7Sudoing §e%s§7:§f %s"

require("@bukkit/send")
local _targets = require("@pierrelasse/bamboo/admincommands/_targets")

addCommand("sudo", function(sender, args)
    local target = _targets.find(sender, args[1])
    if target == nil then
        bukkit.send(sender, MESSAGE_TARGET_NOT_FOUND)
        return
    end
    local msg = table.concat(args, " ", 2)

    local message = string.format(MESSAGE_SUDOING, target.getName(), msg)
    bukkit.send(sender, message)

    target.chat(msg)
end)
    .permission(PERMISSION_COMMAND)
    .complete(function(completions, sender, args)
        if #args == 1 then
            _targets.complete(sender, completions, args[1])
        elseif #args == 2 then
            completions.add("/")
        end
    end)
