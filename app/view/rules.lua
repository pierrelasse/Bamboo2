local screens = require("app/util/screens")


local ITM_LEFT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2RjOWU0ZGNmYTQyMjFhMWZhZGMxYjViMmIxMWQ4YmVlYjU3ODc5YWYxYzQyMzYyMTQyYmFlMWVkZDUifX19",
    "§f§l←"
)

local ITM_RIGHT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTU2YTM2MTg0NTllNDNiMjg3YjIyYjdlMjM1ZWM2OTk1OTQ1NDZjNmZjZDZkYzg0YmZjYTRjZjMwYWI5MzExIn19fQ==",
    "§f§l→"
)


local function view(player)
    local screen = screens.makeScreen("§lRegeln", 9 * 1)

    screens.button(screen, 0, ITM_LEFT, function() end)

    for i = 2, 6 do
        screen:set(i, nil)
    end

    screens.button(screen, 8, ITM_RIGHT, function() end)

    screen:open(player)
end

return view
