local Conversation = classFor("org.bukkit.conversations.Conversation")


return function(player)
    local conversation = Conversation()
    local proceed = player.beginConversation()
    if not proceed then
        bukkit.send(player, "not proceed")
        return
    end

    conversation.acceptInput("hii")
end
