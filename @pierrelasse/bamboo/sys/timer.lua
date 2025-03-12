local storage = require("@pierrelasse/bamboo/util/Storage").new("timer")


Bamboo.timer = {
    ---@type ScriptTask|nil
    task = nil,

    ---@type integer
    time = nil
}

function Bamboo.timer.tick()
    Bamboo.timer.time = Bamboo.timer.time + 1
end

function Bamboo.timer.isRunning()
    return Bamboo.timer.task ~= nil
end

function Bamboo.timer.start()
    if Bamboo.timer.task == nil then
        Bamboo.timer.task = every(20, Bamboo.timer.tick)

        for _, service in pairs(Bamboo.serviceManager.entries) do
            if service.onTimer ~= nil and service.enabled then
                service.onTimer(true)
            end
        end
    end
end

function Bamboo.timer.stop()
    if Bamboo.timer.task ~= nil then
        Bamboo.timer.task.cancel()
        Bamboo.timer.task = nil

        for _, service in pairs(Bamboo.serviceManager.entries) do
            if service.onTimer ~= nil and service.enabled then
                service.onTimer(false)
            end
        end
    end
end

function Bamboo.timer.reset()
    Bamboo.timer.stop()
    Bamboo.timer.time = 0
end

function Bamboo.timer.load()
    storage:loadSave(function()
        storage:set("time", Bamboo.timer.time)
        storage:set("running", Bamboo.timer.isRunning())
    end)
    Bamboo.timer.time = storage:get("time", 0)

    if storage:get("running") == true then
        Bamboo.timer.start()
    end
end
