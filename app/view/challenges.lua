local Material = classFor("org.bukkit.Material")
local ItemStack = classFor("org.bukkit.inventory.ItemStack")

local challengeManager = require("app/challenge/challengeManager")
local screens = require("app/util/screens")


local ITM_LEFT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2RjOWU0ZGNmYTQyMjFhMWZhZGMxYjViMmIxMWQ4YmVlYjU3ODc5YWYxYzQyMzYyMTQyYmFlMWVkZDUifX19",
    "§f§l←"
)

local ITM_RIGHT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTU2YTM2MTg0NTllNDNiMjg3YjIyYjdlMjM1ZWM2OTk1OTQ1NDZjNmZjZDZkYzg0YmZjYTRjZjMwYWI5MzExIn19fQ==",
    "§f§l→"
)


local function view(player, page)
    page = page or 1

    local ITEM_SLOTS = { 2, 3, 4, 5, 6 }

    local challengesIds = table.keys(challengeManager.challenges)
    local currId = 1 + (#ITEM_SLOTS * (page - 1))

    local screen = screens.makeScreen("§lModifikationen", 9 * 1)

    screens.button(screen, 0, ITM_LEFT, function() end)

    for offset = 0, #ITEM_SLOTS - 1 do
        local slot = 2 + offset
        local idIndex = currId + offset
        local challengeId = challengesIds[idIndex]
        if challengeId == nil then
            screen:set(slot, nil)
        else
            local challenge = challengeManager.challenges[challengeId]

            local material = challenge.meta_material or "SPONGE"
            local name = (challenge.enabled and "§a" or "§c")..(challenge.meta_name or challenge.id)
            local lore = {}

            local itemStack = screens.item(material, name, lore)
            screens.button(screen, slot, itemStack, function(event)
                if event.type == "LEFT" then
                    challenge:setEnabled(not challenge.enabled)
                    view(player, page)
                elseif event.type == "RIGHT" then
                end
            end)
        end
    end

    screens.button(screen, 8, ITM_RIGHT, function() end)

    screen:open(player)
end

return view
