local Bukkit = import("org.bukkit.Bukkit")
local EntityDamageEvent = import("org.bukkit.event.entity.EntityDamageEvent")
local PlayerInteractEvent = import("org.bukkit.event.player.PlayerInteractEvent")


---@param service pierrelasse.bamboo.Service
return function(service)
    service.meta_type = "rule"
    service.meta_name = "Freeze when timer paused"
    service.meta_material = "PACKED_ICE"

    local events = {}
    local eventState = false

    ---@param class java.class event class to listen to
    ---@param handler fun(event: java.Object) callback that is called when the event is fired
    ---@return ScriptEvent listener the created event listener
    local function regEvent(class, handler)
        local event = addEvent(class, handler, false)
        events[#events + 1] = event
        return event
    end

    regEvent(EntityDamageEvent, function(event) event.setCancelled(true) end).priority("LOW")
    regEvent(PlayerInteractEvent, function(event) event.setCancelled(true) end).priority("LOW")

    local function activate()
        if eventState then return end
        eventState = true

        Bukkit.getServerTickManager().setFrozen(true)

        for _, event in ipairs(events) do
            event.register()
        end
    end

    local function deactivate()
        if not eventState then return end
        eventState = false

        for _, event in ipairs(events) do
            event.unregister()
        end

        Bukkit.getServerTickManager().setFrozen(false)
    end

    service.onEnable = function()
        if not Bamboo.timer.isRunning() then
            activate()
        end
    end

    service.onDisable = deactivate

    service.onTimer = function(state)
        if state then
            deactivate()
        else
            activate()
        end
    end
end
