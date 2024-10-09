---@param service app.Service
return function(service)
    service.meta_type = "challenge"
    service.meta_name = "Mob Battle Arena Am Ende Des Spiels"
    service.meta_material = "ZOMBIE_SPAWN_EGG"

    service.onTimer = function(state)
    end
end
