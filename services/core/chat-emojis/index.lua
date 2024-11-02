---@param service pierrelasse.bamboo.Service
return function(service)
    service.enabledByDefault = true
    service.meta_type = "core"

    function service.exports(input)
        input = string.replace(input, ":skull:", "💀")
        input = string.replace(input, ":sus:", "ඞ")
        input = string.replace(input, ":peepohey:", "瀐")
        input = string.replace(input, ":schneemann:", "瀑")

        return input
    end
end
