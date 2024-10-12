-- local classloader = require("@core/classloader")
require("@bukkit/index")


-- classloader.addClassFile("@bukkit/components", "bukkit_components_Parser")
-- local Parser = classFor("bukkit_components_Parser")
-- if Parser == nil then error("error loading parser") end

local TextComponent = classFor("net.md_5.bungee.api.chat.TextComponent")


bukkit.components = {}

---@param message string
---@return JavaObject
function bukkit.components.parse(message)
    -- return Parser.parse(message, false)
    return TextComponent.fromLegacy(bukkit.components.convertHex(message))
end

---Converts `§#FFFFFF` into `§x§F§F§F§F§F§F`.
---@param input string
---@return string
function bukkit.components.convertHex(input)
    local output = input:gsub("§#(%x%x%x%x%x%x)", function(hex)
        return "§x§"..hex:sub(1, 1).."§"..hex:sub(2, 2)..
            "§"..hex:sub(3, 3).."§"..hex:sub(4, 4)..
            "§"..hex:sub(5, 5).."§"..hex:sub(6, 6)
    end)
    return output
end
