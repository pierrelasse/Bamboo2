local storage = require("@pierrelasse/bamboo/util/Storage").new("timer")


local this = {
    ---@type ScriptTask?
    task = nil,

    ---@type integer
    time = nil
}

function this.tick()
    this.time = this.time + 1
end

function this.isRunning()
    return this.task ~= nil
end

function this.start()
    if this.task == nil then
        this.task = every(20, this.tick)

        for _, service in pairs(Bamboo.serviceManager.entries) do
            if service.onTimer ~= nil and service.enabled then
                service.onTimer(true)
            end
        end
    end
end

function this.stop()
    if this.task ~= nil then
        this.task.cancel()
        this.task = nil

        for _, service in pairs(Bamboo.serviceManager.entries) do
            if service.onTimer ~= nil and service.enabled then
                service.onTimer(false)
            end
        end
    end
end

function this.reset()
    this.stop()
    this.time = 0
end

function this.load()
    storage:loadSave(function()
        storage:set("time", this.time)
        storage:set("running", this.isRunning())
    end)
    this.time = storage:get("time", 0)

    if storage:get("running") == true then
        this.start()
    end
end

Bamboo.timer = this
