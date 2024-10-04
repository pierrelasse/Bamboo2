local InventoryType = classFor("org.bukkit.event.inventory.InventoryType")

local screens = require("app/util/screens")
local view_challenges = require("app/view/challenges")
local view_rules = require("app/view/rules")


local function view(player)
    local screen = screens.makeScreen("§lMenu", InventoryType.HOPPER)

    screens.button(screen, 1, screens.item("COMPARATOR", "§f§lRegeln"), function()
        player.sendMessage(I18n.g("menu", "rules"))
        view_rules(player)
    end)

    screens.button(screen, 3, screens.item("BOOKSHELF", "§f§lModifikationen"), function()
        player.sendMessage(I18n.g("menu", "modifications"))
        view_challenges(player)
    end)

    screen:open(player)
end

return view
