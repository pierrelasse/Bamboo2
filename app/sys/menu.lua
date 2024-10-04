local view_main = require("app/view/main")


addCommand("menu", function(sender, args)
    sender.sendMessage(I18n.g("menu", "open"))
    view_main(sender)
end).permission("op")
