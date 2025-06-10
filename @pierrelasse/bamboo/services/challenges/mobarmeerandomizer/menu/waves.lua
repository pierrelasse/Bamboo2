local menu_wave = require("@pierrelasse/bamboo/services/challenges/mobarmeerandomizer/menu/wave")


---@param player java.Object
local function waves(player, storage)
    local screen = bukkit.guimaker.Screen.new("Waves", 1)

    local function addWaveButton(id)
        screen:button(
            id - 1, bukkit.buildItem("DIAMOND_SWORD")
            :itemName("Wave "..id)
            :build(), function()
                menu_wave(player, waves, id, storage)
            end)
    end

    addWaveButton(1)
    addWaveButton(2)
    addWaveButton(3)

    local itm = bukkit.buildItem("BLACK_STAINED_GLASS_PANE")
        :hideTooltip()
        :build()
    for i = 3, 8 do
        screen:set(i, itm)
    end

    screen:open(player)
end

return waves
