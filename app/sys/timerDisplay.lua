local timer = require("app/sys/timer")


-- local FORMAT_RUNNING = "<gradient:#707CF7:#F658CF:$offset><b>$time</gradient>"
-- local FORMAT_PAUSED = "<gradient:#5D67CB:#A63D8C:$offset><b>$time</gradient>"
local FORMAT_RUNNING = "<gradient:#F4FDFF:#797977:$offset><b>$time</gradient>"
local FORMAT_PAUSED = "<gradient:#a3a9ab:#454544:$offset><b>$time</gradient>"


-- Von -1 bis 1
local offset = -1

every(5, function()
    if timer.isRunning() then
        offset = offset + 0.05
        if offset > 1 then offset = -1 end
    end
end)

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



---@param time integer
---@return string
local function generate(time)
    local str
    if timer.isRunning() then
        str = FORMAT_RUNNING
    else
        str = FORMAT_PAUSED
    end

    str = string.replace(str, "$offset", tostring(offset))
    str = string.replace(str, "$time", formatTime(timer.time))

    return str
end

every(1, function()
    BroadcastActionBar(generate(timer.time))
end)
