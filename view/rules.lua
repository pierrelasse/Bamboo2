local screens = require("app/util/screens")
local paginator = require("app/view/_paginator")


local ITM_LEFT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2RjOWU0ZGNmYTQyMjFhMWZhZGMxYjViMmIxMWQ4YmVlYjU3ODc5YWYxYzQyMzYyMTQyYmFlMWVkZDUifX19",
    "§f§l←"
)

local ITM_RIGHT = screens.item(
    "HEAD:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTU2YTM2MTg0NTllNDNiMjg3YjIyYjdlMjM1ZWM2OTk1OTQ1NDZjNmZjZDZkYzg0YmZjYTRjZjMwYWI5MzExIn19fQ==",
    "§f§l→"
)


---@param player JavaObject
---@param prevScreenFunc fun(player: JavaObject)
---@param page integer|nil
local function view(player, prevScreenFunc, page)
    page = page or 1

    local screen = screens.makeScreen("§lRegeln ("..page..")", 9 * 1)

    local maxPages = paginator(
        { 2, 3, 4, 5, 6 },
        page,
        function(service) return service.meta_type == "rule" end,
        function(slot, service)
            if service == nil then
                screen:set(slot, nil)
                return
            end

            local material = service.meta_material or "SPONGE"
            local name = (service.enabled and "§a" or "§c")..(service.meta_name or service.id)
            local lore = {}

            local itemStack = screens.item(material, name, lore)
            screens.button(screen, slot, itemStack, function(event)
                if event.type == "LEFT" then
                    service:setEnabled(not service.enabled)
                    view(player, prevScreenFunc, page)
                elseif event.type == "RIGHT" then
                end
            end)
        end
    )

    screens.button(screen, 0, ITM_LEFT, function()
        if page == 1 then
            prevScreenFunc(player)
        else
            view(player, prevScreenFunc, page - 1)
        end
    end)

    screens.button(screen, 8, ITM_RIGHT, function()
        if page <= maxPages then
            view(player, prevScreenFunc, page + 1)
        end
    end)

    screen:open(player)
end

return view
