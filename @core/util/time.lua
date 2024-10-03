local System = classFor("java.lang.System")


local time = {}

---@type fun():number
time.currentMs = function()
    return System.currentTimeMillis()
end

return time
