local Material = import("org.bukkit.Material")


local this = {}
---@type pierrelasse.bamboo.util.Storage
this.storage = nil
---@type java.List<string>
this.randomMaterials = nil
---@type table<string, table<string, any>>
this.cache = nil

function this.getRandomMaterials()
    local mats = makeList()
    for mat in forEach(Material.values()) do
        if  mat.isItem()
        and not mat.isLegacy() then
            mats.add(mat)
        end
    end
    return mats
end

function this.init()
    this.cache = {}

    this.storage:loadSave()

    this.randomMaterials = this.getRandomMaterials()
end

function this.onBlockBreak(event)
    event.setDropItems(false)

    local block = event.getBlock()
    local loc = block.getLocation()

    local id = bukkit.uuid(event.getPlayer())
    local type = tostring(block.getType())

    local key = "blockdrops."..id.."."..type

    ---@type string?
    local material = this.storage:get(key)
    if material == nil then
        material = tostring(this.randomMaterials.get(random:integer(0, this.randomMaterials.size() - 1)))
        this.storage:set(key, material)
    end

    loc.getWorld().dropItemNaturally(
        loc.add(.5, .2, .5),
        bukkit.buildItem(material):build())
end

return this
