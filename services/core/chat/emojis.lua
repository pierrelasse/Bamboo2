---@param input string
---@return string output
return function(input)
    input = string.replace(input, ":skull:", "💀")
    input = string.replace(input, ":sus:", "ඞ")
    input = string.replace(input, ":peepohey:", "瀐")
    input = string.replace(input, ":schneemann:", "瀑")

    return input
end
