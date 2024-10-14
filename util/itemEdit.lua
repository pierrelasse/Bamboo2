-----------------------------
--    Item Edit Script     --
--   Made by pierrelasse   --
-----------------------------

local UUID = classFor("java.util.UUID")
local ArrayList = classFor("java.util.ArrayList")
local Material = classFor("org.bukkit.Material")
local Registry = classFor("org.bukkit.Registry")
local Attribute = classFor("org.bukkit.attribute.Attribute")
local EquipmentSlot = classFor("org.bukkit.inventory.EquipmentSlot")
local EquipmentSlotGroup = classFor("org.bukkit.inventory.EquipmentSlotGroup")
local AttributeModifier = classFor("org.bukkit.attribute.AttributeModifier")
local AttributeModifier_Operation = classFor("org.bukkit.attribute.AttributeModifier$Operation")
-- local SkullMeta = classFor("org.bukkit.inventory.meta.SkullMeta")

require("@bukkit/version")


local MSG_PREFIX = "§2[§aItemEdit§2] §7"
-- local MSG_INVALID_ITEM_TYPE = "§cInvalid item type"


---@class ItemEdit.SubCommand
---@field desc string?
---@field exec fun(player: JavaObject, args: table)
---@field complete fun(completions: JavaObject, player: JavaObject, args: table<number, string>)

---@type table<string, ItemEdit.SubCommand>
local subCommands = {}

---@param name string
---@param data ItemEdit.SubCommand
local function addSubCommand(name, data)
    subCommands[name] = data
end

local function getItemStack(player)
    return player.getInventory().getItemInMainHand()
end

local function send(player, message)
    player.sendMessage(MSG_PREFIX..message)
end

local function join(args, index)
    local result = ""
    local first = true
    while true do
        local arg = args[index]
        if arg == nil then break end
        if first then
            first = false
        else
            result = result.." "
        end
        result = result..arg
        index = index + 1
    end
    return result
end

local function stringifyNSKey(key)
    -- return key.getNamespace()..":"..key.getKey()
    return key.toString()
end

----------------------------------
--         Main Command         --
----------------------------------

addCommand("ie", function(sender, args)
    -- if sender.getGameMode().name() ~= "CREATIVE" then
    --     sender.sendMessage("§cYou need to be in creative mode")
    --     return
    -- end

    if args[1] == nil then
        local msg = "§cUsage: /ie"
        for name, subCommand in pairs(subCommands) do
            msg = msg.."\n §f/ie "..name
            if subCommand.desc ~= nil then
                msg = msg.." §8- §7"..subCommand.desc
            end
        end
        send(sender, msg)
        return
    end

    local subCommand = subCommands[args[1]]
    if subCommand == nil then
        sender.sendMessage("§cSub-Command not found")
        return
    end
    subCommand.exec(sender, args)
end).complete(function(completions, sender, args)
    -- if sender.getGameMode().name() ~= "CREATIVE" then
    --     completions.add("You need to be in creative mode")
    --     return
    -- end

    if #args == 1 then
        for name in pairs(subCommands) do
            completions.add(name)
        end
    elseif #args > 1 then
        local subCommand = subCommands[args[1]]
        if subCommand ~= nil and subCommand.complete ~= nil then
            subCommand.complete(completions, sender, args)
        end
    end
end).permission("op")

----------------------------------
--         Sub Commands         --
----------------------------------

-- https://github.com/emanondev/ItemEdit/tree/master/src/main/java/emanondev/itemedit/command/itemedit

addSubCommand("amount", {
    desc = "Stack size",
    exec = function(player, args)
        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        local amount = tonumber(args[2])
        itemStack.setAmount(amount)
        send(player, "Set amount to §f"..amount)
    end,
    complete = function(completions, player, args)
        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        completions.add("1")
        completions.add("10")
        completions.add("64")
        completions.add("100")
        completions.add("127")

        completions.add(tostring(itemStack.getAmount()))
    end
})

do
    local actions = { "add", "remove" }

    addSubCommand("attribute", {
        exec = function(player, args)
            local itemStack = getItemStack(player)
            if itemStack == nil then return end

            local action = table.key(actions, args[2])
            if action == nil then
                send(player, "§cUsage: /ie attribute <add|remove> ...")
                return
            end

            -- add <attribute> amount [operation] [equip]
            if action == 1 then
                local attribute
                if args[3] ~= nil then
                    for i in forEach(Attribute.values()) do
                        if i.getKey().toString() == args[3] then
                            attribute = i
                            break
                        end
                    end
                end
                if attribute == nil then
                    send(player, "§cInvalid attribute")
                    return
                end

                local amount = tonumber(args[4])
                if amount == nil then
                    send(player, "§cInvalid amount")
                    return
                end

                local operation
                for i in forEach(AttributeModifier_Operation.values()) do
                    if i.toString() == args[5] then
                        operation = i
                        break
                    end
                end
                if operation == nil then
                    send(player, "§cInvalid operation")
                    return
                end

                local slot
                for i in forEach(EquipmentSlot.values()) do
                    i = i.toString()
                    if i == args[6] then
                        slot = i
                        break
                    end
                end

                local modifier
                if bukkit.version.after(1, 20, 6) then
                    local group
                    if slot == nil then
                        group = EquipmentSlotGroup.ANY
                    else
                        group = EquipmentSlotGroup.ANY
                        print("NOT ANY TODO") -- TODO
                    end

                    modifier = AttributeModifier(
                        UUID.randomUUID(),
                        attribute.getKey().toString(),
                        amount,
                        operation,
                        group
                    )
                else
                    if slot == nil then
                        send(player, "§cInvalid slot")
                        return
                    end

                    modifier = AttributeModifier(
                        UUID.randomUUID(),
                        attribute.getKey().toString(),
                        amount,
                        operation,
                        slot
                    )
                end

                local meta = itemStack.getItemMeta()
                if meta == nil then return end
                meta.addAttributeModifier(attribute, modifier)
                itemStack.setItemMeta(meta)

                send(player,
                     "Added attribute §f"..
                     attribute.getKey().toString()..
                     "§7 with amount §f"..amount.."§7 to §f"
                     ..args[6].."§7 and operation §f".."???") -- operation.toString()

                return
            end

            if action == 2 then
                send(player, "§cComing soon") -- TODO
            end
        end,
        complete = function(completions, player, args)
            if #args == 2 then
                for _, action in ipairs(actions) do
                    completions.add(action)
                end
                return
            end

            local action = table.key(actions, args[2])
            if action == nil then return end

            local function completeAttributes()
                for attribute in forEach(Attribute.values()) do
                    completions.add(attribute.getKey().toString())
                end
            end

            local function completeSlots()
                -- TODO: EquipmentSlotGroup
                for equipmentSlot in forEach(EquipmentSlot.values()) do
                    completions.add(equipmentSlot.toString())
                end
            end

            if #args == 3 then
                completeAttributes()
                if action == 2 then
                    completeSlots()
                end
                return
            end

            if action ~= 1 then return end

            if #args == 4 then
                completions.add("<amount>")
                return
            end

            if #args == 5 then
                for i in forEach(AttributeModifier_Operation.values()) do
                    completions.add(i.toString())
                end
                return
            end

            if #args == 6 then
                completeSlots()
            end
        end
    })
end

-- axolotlvariant
-- banner
-- bookauthor
-- bookenchant
-- booktype
-- color
-- colorold
-- compass
-- custommodeldata

addSubCommand("damage", {
    desc = "How many times it's been used (ignores unbreaking ench)",
    exec = function(player, args)
        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        local damage = tonumber(args[2])
        if damage == nil then
            send(player, "§cInvalid damage")
            return
        end
        damage = math.max(0, math.min(damage, itemStack.getType().getMaxDurability()))

        itemStack.setDurability(damage)

        send(player, "Set damage to §f"..damage)
    end,
    complete = function(completions, player, args)
        if #args == 2 then
            completions.add("0")

            local itemStack = getItemStack(player)
            if itemStack == nil then return end

            local max = itemStack.getType().getMaxDurability()
            if max > 0 then
                completions.add(tostring(max))
                completions.add(tostring(math.floor(max / 2)))
                completions.add(tostring(math.floor(max / 4)))
                completions.add(tostring(math.floor(max / 4 * 3)))
            end
        end
    end
})

do
    local function getNSKey(s)
        for enchant in forEach(Registry.ENCHANTMENT) do
            local key = enchant.getKey()
            if stringifyNSKey(key) == s then
                return key
            end
        end
    end

    addSubCommand("enchant", {
        desc = "Enchantments",
        exec = function(player, args)
            local itemStack = getItemStack(player)
            if itemStack == nil then return end

            local enchantment = args[2]
            local enchantmentKey = getNSKey(enchantment)
            if enchantmentKey == nil then
                send(player, "§cEnchantment not found")
                return
            end

            enchantment = Registry.ENCHANTMENT.get(enchantmentKey)
            if enchantment == nil then
                send(player, "§cInvalid enchantment")
                return
            end

            local level = tonumber(args[3])

            if level == nil then
                if #args >= 3 then
                    send(player, "§cInvalid level")
                    return
                end

                level = -1
                send(player, "Level of §f"..stringifyNSKey(enchantmentKey).."§8: §f"..level)
                return
            end

            if level == 0 then
                itemStack.removeEnchantment(enchantment)
                send(player, "Removed enchantment §f"..stringifyNSKey(enchantmentKey))
                return
            end

            itemStack.addUnsafeEnchantment(enchantment, level)
            send(player, "Added enchantment §f"..stringifyNSKey(enchantmentKey).."§7 level §f"..level)
        end,
        complete = function(completions, player, args)
            if #args == 2 then
                for enchant in forEach(Registry.ENCHANTMENT) do
                    local key = enchant.getKey()
                    completions.add(stringifyNSKey(key))
                end
            elseif #args == 3 then
                completions.add("0")

                local key = getNSKey(args[2])
                if key ~= nil then
                    local enchantment = Registry.ENCHANTMENT.get(key)
                    if enchantment ~= nil then
                        local maxLevel = enchantment.getMaxLevel()
                        for i = 1, maxLevel, 1 do
                            completions.add(tostring(i))
                        end
                    end
                end
            end
        end
    })
end

-- fireresistent
-- firework
-- firework power
-- food
-- glow
-- goathornsound
-- hide
-- hideall
-- hidetooltip
-- listaliases

do
    local actions = { "add", "set", "remove", "clear", "insert", "copy", "copybook", "copyfile", "paste", "replace" }

    addSubCommand("lore", {
        desc = "Description",
        exec = function(player, args)
            if args[2] == nil then
                send(player, "§cUsage: /ie lore <"..table.concat(actions, "|").."> ...")
                return
            end
            local action = table.key(actions, args[2])
            if action == nil then
                send(player, "§cAction not found")
                return
            end

            local itemStack = getItemStack(player)
            if itemStack == nil then return end

            local meta = itemStack.getItemMeta()
            if meta == nil then return end

            local function getNewLines()
                if #args < 3 then return {} end
                local text = table.concat(args, " ", 3)
                local coloredText = string.replace(text, "&", "§")
                return string.split2(coloredText, "\\n")
            end

            local lore = meta.getLore() or ArrayList()

            if action == 1 then     -- add

            elseif action == 2 then -- set
                lore.clear()
                for _, line in ipairs(getNewLines()) do lore.add(line) end

                send(player, "Lore set")
            elseif action == 3 then -- remove
            elseif action == 4 then -- clear
                lore = nil
                send(player, "Lore removed")
            elseif action == 5 then  -- insert
            elseif action == 6 then  -- copy
            elseif action == 7 then  -- copybook
            elseif action == 8 then  -- copyfile
            elseif action == 9 then  -- paste
            elseif action == 10 then -- replace
            end

            meta.setLore(lore)
            itemStack.setItemMeta(meta)
        end,
        complete = function(completions, player, args)
            if #args == 2 then
                for _, action in ipairs(actions) do
                    completions.add(action)
                end
            end
        end
    })
end

-- maxdurability
-- maxstacksize
-- potioneffecteditor
-- potioneffecteditorold
-- rarity

addSubCommand("rename", {
    desc = "Display name",
    exec = function(player, args)
        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        local meta = itemStack.getItemMeta()
        if meta == nil then return end

        local displayName = join(args, 2)
        displayName = string.replace(displayName, "&", "§")

        meta.setDisplayName(displayName)

        itemStack.setItemMeta(meta)

        send(player, "Renamed to §f"..displayName)
    end,
    complete = function(completions, player, args)
        if #args == 2 then
            local itemStack = getItemStack(player)
            if itemStack == nil then return end

            local meta = itemStack.getItemMeta()
            if meta == nil then return end

            local displayName = meta.getDisplayName()
            displayName = string.replace(displayName, "§", "&")

            completions.add(displayName)
        end
    end
})

-- repaircost

-- registerSubCommand("skullowner", {
--     exec = function(player, args)
--         local itemStack = getItemStack(player)
--         if itemStack == nil then return end

--         local meta = itemStack.getItemMeta()
--         if meta == nil then return end
--         if not instanceof(meta, SkullMeta) then
--             send(player, MSG_INVALID_ITEM_TYPE)
--             return
--         end

--         local name = args[2]
--         if name == nil then
--             meta.setOwner(nil)
--             send(player, "Removed owner")
--             return
--         else
--             if string.length(name) < 3 or string.length(name) > 16 then
--                 send(player, "§cInvalid name")
--                 return
--             end

--             meta.setOwner(name)
--             send(player, "Set owner to §f"..name)
--         end

--         itemStack.setItemMeta(meta)
--         player.updateInventory()
--     end,
--     complete = function(completions, player, args)
--     end
-- })

-- spawneggtype
-- trim
-- tropicalfish

addSubCommand("type", {
    desc = "Material",
    exec = function(player, args)
        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        local materialArg = args[2]
        local materialObj

        for i = 0, 1 do
            for material in forEach(Material.values()) do
                if not material.isLegacy() and material.isItem() then
                    if i == 0 then
                        if materialArg == stringifyNSKey(material.getKey()) then
                            materialObj = material
                            break
                        end
                    else
                        if materialArg == material.getKey().getKey() then
                            materialObj = material
                            break
                        end
                    end
                end
            end
            if materialObj ~= nil then break end
        end

        if materialObj == nil then
            send(player, "§cMaterial not found")
            return
        end

        itemStack.setType(materialObj)
        send(player, "Set material to §f"..stringifyNSKey(materialObj.getKey()))
    end,
    complete = function(completions, player, args)
        if #args == 2 then
            local prefix = args[2]

            local completes = 200
            for material in forEach(Material.values()) do
                if completes == 0 then break end

                if not material.isLegacy() and material.isItem() then
                    local key = material.getKey()
                    local result = stringifyNSKey(key)
                    if string.startswith(key.getKey(), prefix) or string.startswith(result, prefix) then
                        completes = completes - 1
                        completions.add(result)
                    end
                end
            end
        end
    end
})

addSubCommand("unbreakable", {
    desc = "Unbreakable flag",
    exec = function(player, args)
        local state = args[2] == nil or args[2] == "true"
        if not state and args[2] ~= "false" then
            send(player, "§cInvalid state")
            return
        end

        local itemStack = getItemStack(player)
        if itemStack == nil then return end

        local meta = itemStack.getItemMeta()
        if meta == nil then return end

        meta.setUnbreakable(state)

        itemStack.setItemMeta(meta)

        if state then
            send(player, "Made item unbreakable")
        else
            send(player, "Made item no longer unbreakable")
        end
    end,
    complete = function(completions, player, args)
        if #args == 2 then
            local currentState
            local itemStack = getItemStack(player)
            if itemStack ~= nil then
                local meta = itemStack.getItemMeta()
                if meta ~= nil then
                    currentState = meta.isUnbreakable()
                end
            end
            if currentState ~= true then
                completions.add("true")
            end
            if currentState ~= false then
                completions.add("false")
            end
        end
    end
})
