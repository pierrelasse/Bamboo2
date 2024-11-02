local InventoryType = classFor("org.bukkit.event.inventory.InventoryType")

local screens = require("@pierrelasse/bamboo/util/screens")
local view_challenges = require("@pierrelasse/bamboo/services/core/menu/view/challenges")
local view_rules = require("@pierrelasse/bamboo/services/core/menu/view/challenges")


local function view(player)
    local screen = screens.makeScreen("§f七七七七七七七ㇺ", InventoryType.HOPPER)

    screens.button(screen, 1, screens.item("COMPARATOR", "§f§lRegeln"), function()
        player.sendMessage("menu.rules")
        view_rules(player, view)
    end)

    screens.button(screen, 3, screens.item("BOOKSHELF", "§f§lModifikationen"), function()
        player.sendMessage("menu.mods")
        view_challenges(player, view)
    end)

    screen:open(player)
end

return view
