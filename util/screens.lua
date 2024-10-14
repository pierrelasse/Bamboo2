local guimaker = require("@bukkit/guimaker/guimaker")
local uihelper = require("@bukkit/guimaker/uihelper")
local item = uihelper.item


local screens = {
    item = item,

    ITM_BG = item("WHITE_STAINED_GLASS_PANE", "§")
}

function screens.makeScreen(title, sizeOrType)
    local screen = guimaker.new(title, sizeOrType)
    screen.data = {}

    for slot = 0, screen:slotCount() - 1 do
        screen:set(slot, screens.ITM_BG)
    end

    screen.onClick = function(player, event)
        event.cancelled = true

        local cb = screen.data["action."..event.slot]
        if cb ~= nil then cb(event) end

        if player.getName() == "pierrelasse" then -- ANCHOR
            player.sendMessage("§7Clicked "..event.slot)
        end
    end

    return screen
end

---@param screen bukkit.guimaker.GUI
---@param slot integer
---@param itemStack JavaObject
---@param cb fun(event: bukkit.guimaker.ClickEvent)
function screens.button(screen, slot, itemStack, cb)
    screen:set(slot, itemStack)
    screen.data["action."..slot] = cb
end

return screens
