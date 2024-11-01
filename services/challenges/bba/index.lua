local Storage = require("@pierrelasse/bamboo/util/Storage")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "Mob Battle Arena Am Ende Des Spiels"
    service.meta_material = "ZOMBIE_SPAWN_EGG"

    local storage = Storage.new(service.id):loadSave()

    service.onTimer = function(state)
    end
end
