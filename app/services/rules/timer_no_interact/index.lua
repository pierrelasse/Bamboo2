local Bukkit = classFor("org.bukkit.Bukkit")
local EntityDamageEvent = classFor("org.bukkit.event.entity.EntityDamageEvent")
local PlayerInteractEvent = classFor("org.bukkit.event.player.PlayerInteractEvent")


---@param service app.Service
return function(service)
    service.meta_type = "rule"
    service.meta_name = "Freeze when timer paused"
    service.meta_material = "PACKED_ICE"

    local events = {}
    local eventState = false

    ---@type ScriptEvent[]
    ---@generic T : JavaObject
    ---@param eventClass T The class of the event.
    ---@param handler fun(event: T) The event handler.
    local function regEvent(eventClass, handler)
        local event = addEvent(eventClass, handler, false)
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
        if not Timer.isRunning() then
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
