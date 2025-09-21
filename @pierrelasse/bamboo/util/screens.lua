local guimaker = require("@bukkit/guimaker/guimaker")


local screens = {
    ITM_BG = bukkit.buildItem("WHITE_STAINED_GLASS_PANE")
        :hideTooltip()
        :build()
}

function screens.makeScreen(title, sizeOrType, bg)
    local screen = guimaker.new(title, sizeOrType)
    screen.data = {}

    if bg ~= nil then
        for slot = 0, screen:slotCount() - 1 do
            screen:set(slot, bg)
        end
    end

    screen.onClick = function(player, event)
        event.cancelled = true

        local cb = screen.data["action."..event.slot]
        if cb ~= nil then cb(event) end
    end

    return screen
end

---@param screen bukkit.guimaker.GUI
---@param slot integer
---@param itemStack bukkit.ItemStack?
---@param cb fun(event: bukkit.guimaker.ClickEvent)
function screens.button(screen, slot, itemStack, cb)
    screen:set(slot, itemStack)
    screen.data["action."..slot] = cb
end

return screens
