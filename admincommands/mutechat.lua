local PERMISSION_COMMAND = "admin.mutechat"
local PERMISSION_BYPASS = "admin.mutechat.bypass"
local MESSAGE_MUTE = "§cThe chat was muted by §4%s§c!"
local MESSAGE_MUTE_ALREADY = "§cThe chat is already muted!"
local MESSAGE_UNMUTE = "§aThe chat was unmuted by §2%s§a!"
local MESSAGE_UNMUTE_ALREADY = "§cThe chat is already unmuted!"
local MESSAGE_MUTED = "§cThe chat is currently muted!"

local AsyncPlayerChatEvent = classFor("org.bukkit.event.player.AsyncPlayerChatEvent")


local ev =
    addEvent(AsyncPlayerChatEvent, function(event)
                 local player = event.getPlayer()
                 if player.hasPermission(PERMISSION_BYPASS) then
                     return
                 end
                 event.setCancelled(true)

                 bukkit.send(player, MESSAGE_MUTED)
             end, false)
    .priority("LOW")
local muted = false


addCommand("mutechat", function(sender, args)
    local announce = args[2] ~= "-s"

    if args[1] ~= "off" then
        if muted then
            bukkit.send(sender, MESSAGE_MUTE_ALREADY)
            return
        end
        ev.register()
        muted = true

        local message = string.format(MESSAGE_MUTE, sender.getName())
        if not announce then
            message = "§7(Silent) §r"..message
        end
        for player in bukkit.onlinePlayersLoop() do
            if announce or player.hasPermission(PERMISSION_COMMAND) then
                player.sendMessage(message)
            end
        end
    else
        if not muted then
            bukkit.send(sender, MESSAGE_UNMUTE_ALREADY)
            return
        end

        ev.unregister()
        muted = false

        local message = string.format(MESSAGE_UNMUTE, sender.getName())
        if not announce then
            message = "§7(Silent) §r"..message
        end
        for player in bukkit.onlinePlayersLoop() do
            if announce or player.hasPermission(PERMISSION_COMMAND) then
                player.sendMessage(message)
            end
        end
    end
end)
    .permission(PERMISSION_COMMAND)
    .complete(function(completions, sender, args)
        if #args == 1 then
            completions.add(muted and "off" or "on")
        elseif #args == 2 then
            completions.add("-s")
        end
    end)
