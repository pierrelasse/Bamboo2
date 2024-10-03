local classloader = require("@core/classloader")
classloader.addClassFile("@extra/guimaker", "guimaker_GUIHolder")

local GUIHolder = classFor("guimaker_GUIHolder")
if GUIHolder == nil then error("failed loading class") end

local InventoryCloseEvent = classFor("org.bukkit.event.inventory.InventoryCloseEvent")
local InventoryClickEvent = classFor("org.bukkit.event.inventory.InventoryClickEvent")
local InventoryDragEvent = classFor("org.bukkit.event.inventory.InventoryDragEvent")


local guimaker = {
    GUIHolder = GUIHolder
}

---@class extra.guimaker.ClickEvent
---@field event JavaObject org.bukkit.event.inventory.InventoryClickEvent
---@field cancelled boolean
---@field type "LEFT"
---    |"SHIFT_LEFT"
---    |"RIGHT"
---    |"SHIFT_RIGHT"
---    |"WINDOW_BORDER_LEFT"
---    |"WINDOW_BORDER_RIGHT"
---    |"MIDDLE"
---    |"NUMBER_KEY"
---    |"DOUBLE_CLICK"
---    |"DROP"
---    |"CONTROL_DROP"
---    |"CREATIVE"
---    |"SWAP_OFFHAND"
---    |"UNKNOWN"
---@field action "NOTHING"
---    |"PICKUP_ALL"
---    |"PICKUP_SOME"
---    |"PICKUP_HALF"
---    |"PICKUP_ONE"
---    |"PLACE_ALL"
---    |"PLACE_SOME"
---    |"PLACE_ONE"
---    |"SWAP_WITH_CURSOR"
---    |"DROP_ALL_CURSOR"
---    |"DROP_ONE_CURSOR"
---    |"DROP_ALL_SLOT"
---    |"DROP_ONE_SLOT"
---    |"MOVE_TO_OTHER_INVENTORY"
---    |"HOTBAR_MOVE_AND_READD"
---    |"HOTBAR_SWAP"
---    |"CLONE_STACK"
---    |"COLLECT_TO_CURSOR"
---    |"UNKNOWN"
---@field slotType "RESULT"
---    |"CRAFTING"
---    |"ARMOR"
---    |"CONTAINER"
---    |"QUICKBAR"
---    |"OUTSIDE"
---    |"FUEL"
---@field slot integer
---@field itemStack JavaObject

---@class extra.guimaker.DragEvent
---@field event JavaObject

---@param inventory JavaObject
---@return GUI?
local function getGUI(inventory)
    if inventory == nil then return end
    local holder = inventory.getHolder()
    if not instanceof(holder, GUIHolder) then return end
    return holder.gui
end

---@class GUI
---
---@field inventory JavaObject
---@field data any?
---
---@field onOpen fun(player: JavaObject)?
---@field onClose fun(player: JavaObject)?
---@field onClick fun(player: JavaObject, event: extra.guimaker.ClickEvent)|nil?
---@field onClickOther fun(player: JavaObject, event: extra.guimaker.ClickEvent)|nil?
---@field onDrag fun(player: JavaObject, event: extra.guimaker.DragEvent)?
---@field onTick fun(player: JavaObject)?
---
local GUI = {}
GUI.__index = GUI

---@param title string
---@param sizeOrType? integer|JavaObject
---@return GUI
function guimaker.new(title, sizeOrType)
    local self = setmetatable({}, GUI)

    self.inventory = (GUIHolder(self, title, sizeOrType or (9 * 6))).getInventory()

    return self
end

function GUI:open(player)
    player.openInventory(self.inventory)
end

function GUI:close(player)
    if self:hasOpen(player) then
        player.closeInventory()
    end
end

function GUI:hasOpen(player)
    return getGUI(player.getOpenInventory().getTopInventory()) == self
end

function GUI:slotCount()
    return self.inventory.getSize()
end

---@param slot integer
---@param itemStack JavaObject
function GUI:set(slot, itemStack)
    self.inventory.setItem(slot, itemStack)
end

local function registerEvents()
    addEvent(InventoryCloseEvent, function(event)
        local gui = getGUI(event.getInventory())
        if gui == nil or gui.onClose == nil then return end
        gui.onClose(nil)
    end)

    addEvent(InventoryClickEvent, function(event)
        local clickedInv = event.getClickedInventory()
        if clickedInv == nil then return end

        local view = event.getView()
        local topInv = view.getTopInventory()

        local gui = getGUI(topInv)
        if gui == nil then return end

        --- @type extra.guimaker.ClickEvent
        local ev = {
            event = event,
            cancelled = event.isCancelled(),
            type = event.getClick().name(),
            action = event.getAction().name(),
            slotType = event.getSlotType().name(),
            slot = event.getSlot(),
            itemStack = event.getCurrentItem()
        }

        local player = event.getWhoClicked()

        if topInv.equals(clickedInv) then
            if gui.onClick ~= nil then
                gui.onClick(player, ev)
            end
        elseif gui.onClickOther ~= nil then
            gui.onClickOther(player, ev)
        end

        event.setCancelled(ev.cancelled)
    end)

    addEvent(InventoryDragEvent, function(event)
        local gui = getGUI(event.getInventory())
        if gui == nil or gui.onDrag == nil then return end
        gui.onDrag(event.getWhoClicked(), {
            event = event
        })
    end)
end

registerEvents()

return guimaker
