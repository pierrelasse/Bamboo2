local storage = require("app/util/Storage").new("timer")


Timer = {
    ---@type ScriptTask|nil
    task = nil,

    ---@type integer
    time = nil
}

function Timer.tick()
    Timer.time = Timer.time + 1
end

function Timer.isRunning()
    return Timer.task ~= nil
end

function Timer.start()
    if Timer.task == nil then
        Timer.task = every(20, Timer.tick)
    end
end

function Timer.stop()
    if Timer.task ~= nil then
        Timer.task.cancel()
        Timer.task = nil
    end
end

function Timer.reset()
    Timer.stop()
    Timer.time = 0
end

storage:loadSave(function()
    storage:set("time", Timer.time)
    storage:set("running", Timer.isRunning())
end)
Timer.time = storage:get("time", 0)

if storage:get("running") == true then
    Timer.start()
end

return Timer
