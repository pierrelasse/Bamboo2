---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    ---range -1-1
    local offset = -1
    ---@type ScriptTask
    local task

    local function formatTime(locale, seconds)
        local days = math.floor(seconds / 86400)
        local hours = math.floor((seconds % 86400) / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60

        local function formatUnit(value, singular, plural)
            return string.format("%d %s", value, Bamboo.translate(
                locale, "generic."..(value == 1 and singular or plural)))
        end

        if days > 0 then
            return string.format("%s %s %s %s",
                                 formatUnit(days, "day", "days"),
                                 formatUnit(hours, "hour", "hours"),
                                 formatUnit(minutes, "minute", "minutes"),
                                 formatUnit(secs, "second", "seconds"))
        elseif hours > 0 then
            return string.format("%s %s %s",
                                 formatUnit(hours, "hour", "hours"),
                                 formatUnit(minutes, "minute", "minutes"),
                                 formatUnit(secs, "second", "seconds"))
        elseif minutes > 0 then
            return string.format("%s %s",
                                 formatUnit(minutes, "minute", "minutes"),
                                 formatUnit(secs, "second", "seconds"))
        else
            return formatUnit(secs, "second", "seconds")
        end
    end

    local function generate(locale)
        local key = Bamboo.timer.isRunning()
            and "services.core/timerDisplay.running"
            or "services.core/timerDisplay.paused"
        return comp.mm(Bamboo.translateF(locale, key, 0 - offset, formatTime(locale, Bamboo.timer.time)))
    end

    service.onEnable = function()
        task = every(1, function()
            if Bamboo.timer.isRunning() then
                offset = offset + 0.01
                if offset > 1 then offset = -1 end
            end

            local translated = {}
            for player in bukkit.playersLoop() do
                local locale = Bamboo.getLocale(player)
                local comp = translated[locale] or generate(locale)
                player.sendActionBar(comp)
            end
        end)
    end

    service.onDisable = function()
        task.cancel()
    end
end
