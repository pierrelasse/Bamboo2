local mobitem = require("@pierrelasse/bamboo/services/challenges/mobarmeerandomizer/mobitem")
local mobtranslations = require("@pierrelasse/bamboo/services/challenges/mobarmeerandomizer/mobtranslations")


---@param player java.Object
---@param prevScreen function
---@param id number
---@param storage pierrelasse.bamboo.util.Storage
local function waves(player, prevScreen, id, storage)
    local playerId = bukkit.uuid(player)

    local screen = bukkit.guimaker.Screen.new("Wave Konfiguration", 6)

    screen:button(
        0, bukkit.buildItem("RED_CONCRETE"):itemName("§cZurück"):build(),
        function()
            prevScreen(player, storage)
        end
    )

    for i = 1, 8 do
        screen:set(i, bukkit.buildItem("WHITE_STAINED_GLASS_PANE"):hideTooltip():build())
    end

    local function getPlaced(entityType)
        return storage:get("placed."..playerId.."."..id.."."..entityType, 0)
    end

    local function getGlobalPlaced(entityType)
        local amount = 0
        for iId in storage:loopKeys("placed."..playerId) do
            amount = amount + storage:get("placed."..playerId.."."..iId.."."..entityType, 0)
        end
        return amount
    end

    local function getAvailable(entityType)
        return storage:get("available."..playerId.."."..entityType, 0) - getGlobalPlaced(entityType)
    end

    ---@type (fun(): string)?
    local availableLoop = storage:loopKeys("available."..playerId)
    for slot = 9, 53 do
        local entityType = availableLoop ~= nil and availableLoop() or nil
        if entityType == nil then
            availableLoop = nil
            screen:set(slot, bukkit.buildItem("BLACK_STAINED_GLASS_PANE"):hideTooltip():build())
        else
            local itemPlaced = getPlaced(entityType)
            screen:button(
                slot, bukkit.buildItem(mobitem(entityType))
                :itemName(mobtranslations[entityType] or entityType)
                :lore({
                    "§fEingesetzt: "..itemPlaced,
                    "§fVerfügbar: "..getAvailable(entityType),
                    "",
                    "§7Linksklick zum hinzufügen",
                    "§7Rechtsklick zum entfernen"
                })
                :build(),
                function(event)
                    local eventPlaced = getPlaced(entityType)
                    if event.type == "LEFT" then
                        if getAvailable(entityType) > 0 then
                            storage:set("placed."..playerId.."."..id.."."..entityType, eventPlaced + 1)
                        end
                    elseif event.type == "RIGHT" then
                        if eventPlaced > 0 then
                            storage:set("placed."..playerId.."."..id.."."..entityType, eventPlaced - 1)
                        end
                    else
                        return
                    end
                    bukkit.playSound(player, "ui.button.click", .4, 1.6)
                    waves(player, prevScreen, id, storage)
                end
            )
        end
    end

    screen:open(player)
end

return waves
