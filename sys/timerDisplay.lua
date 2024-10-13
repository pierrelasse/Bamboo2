local FORMAT_RUNNING = "<gradient:#F4FDFF:#797977:$offset><b>$time</gradient>"
local FORMAT_PAUSED = "<gradient:#a3a9ab:#454544:$offset><b>$time</gradient>"

---range -1-1
local offset = -1

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    local function formatUnit(value, singular, plural)
        return string.format("%d %s", value, value == 1 and singular or plural)
    end

    if days > 0 then
        return string.format("%s %s %s %s",
                             formatUnit(days, "Tag", "Tage"),
                             formatUnit(hours, "Stunde", "Stunden"),
                             formatUnit(minutes, "Minute", "Minuten"),
                             formatUnit(secs, "Sekunde", "Sekunden"))
    elseif hours > 0 then
        return string.format("%s %s %s",
                             formatUnit(hours, "Stunde", "Stunden"),
                             formatUnit(minutes, "Minute", "Minuten"),
                             formatUnit(secs, "Sekunde", "Sekunden"))
    elseif minutes > 0 then
        return string.format("%s %s",
                             formatUnit(minutes, "Minute", "Minuten"),
                             formatUnit(secs, "Sekunde", "Sekunden"))
    else
        return formatUnit(secs, "Sekunde", "Sekunden")
    end
end

---@return string
local function generate()
    local str
    if Timer.isRunning() then
        str = FORMAT_RUNNING
    else
        str = FORMAT_PAUSED
    end

    str = string.replace(str, "$offset", tostring(0 - offset))
    str = string.replace(str, "$time", formatTime(Timer.time))

    return str
end

every(1, function()
    if Timer.isRunning() then
        offset = offset + 0.01
        if offset > 1 then offset = -1 end
    end

    BroadcastActionBar(generate())
end)
