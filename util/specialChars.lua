local char = Bamboo.Helper.stringFromCodePoint

local list = {
    rank_vip        = char(28674),
    rank_mod        = char(28675),
    generic_blacksc = char(28676),
    rank_dev        = char(28677),
    rank_team       = char(28678),
    --              = char(28679),
    --              = char(28680),
    --              = char(28681),
    --              = char(28682),
    --              = char(28683),
    --              = char(28684),
    --              = char(28685),
    --              = char(28686),
    --              = char(28687),
    emoji_peepohey  = char(28688),
    emoji_snowman   = char(28689),
    fun_tengoku     = char(28690),
    fun_tengoku2    = char(28691),
}


local ClickEvent = classFor("net.md_5.bungee.api.chat.ClickEvent")
local ClickEvent_Action = classFor("net.md_5.bungee.api.chat.ClickEvent$Action")
local ComponentBuilder = classFor("net.md_5.bungee.api.chat.ComponentBuilder")
local TextComponent = classFor("net.md_5.bungee.api.chat.TextComponent")


function Bamboo.specialChar(sender)
    if sender == nil then return end

    local builder = ComponentBuilder()

    builder.append(TextComponent("§7Special chars (click to copy):"))

    for iId, iValue in pairs(list) do
        do
            local comp = TextComponent("\n ")
            builder.append(comp)
        end
        do
            local comp = TextComponent(iId)
            comp.setClickEvent(ClickEvent(ClickEvent_Action.COPY_TO_CLIPBOARD, iId))
            builder.append(comp)
        end
        do
            local comp = TextComponent(" §8- ")
            builder.append(comp)
        end
        do
            local comp = TextComponent(iValue.."  ")
            comp.setClickEvent(ClickEvent(ClickEvent_Action.COPY_TO_CLIPBOARD, iValue))
            builder.append(comp)
        end
    end

    bukkit.sendComponent(sender, builder.build())
end

function Bamboo.codePoint(str)
    return Bamboo.Helper.codePointFromString(str)
end

return list
