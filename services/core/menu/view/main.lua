local InventoryType = classFor("org.bukkit.event.inventory.InventoryType")

local screens = require("@pierrelasse/bamboo/util/screens")
local view_challenges = require("@pierrelasse/bamboo/services/core/menu/view/challenges")
local view_rules = require("@pierrelasse/bamboo/services/core/menu/view/challenges")


local function view(player)
    local locale = Bamboo.getLocale(player)

    local screen = screens.makeScreen("§f七七七七七七七ㇺ", InventoryType.HOPPER)

    local offset = -1

    local task = every(1, function()
        offset = offset - .05
        if offset < -1 then
            offset = 1
        end

        do
            local itm = bukkit.buildItem("COMPARATOR")
            itm.meta.displayName(ToMiniMessage("<gradient:#4CE400:#2E5B0D:"..offset.."><b>"..
                Bamboo.translate(locale, "services.core/menu.main.rules")))
            screen:set(1, itm:build())
        end

        do
            local itm = bukkit.buildItem("BOOKSHELF")
            itm.meta.displayName(ToMiniMessage("<gradient:#4CE400:#2E5B0D:"..offset.."><b>"..
                Bamboo.translate(locale, "services.core/menu.main.mods")))
            screen:set(3, itm:build())
        end
    end)

    screen.onClose = function()
        task.cancel()
    end

    screens.button(screen, 1, nil, function()
        view_rules(player, view)
    end)

    screens.button(screen, 3, nil, function()
        view_challenges(player, view)
    end)

    screen:open(player)
end

return view
