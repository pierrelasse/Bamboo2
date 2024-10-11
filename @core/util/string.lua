function string.startswith(s, prefix)
    return string.sub(s, 1, #prefix) == prefix
end

function string.endsWith(s, ending)
    return string.sub(s, - #ending) == ending
end

function string.replace(s, what, with)
    local result = string.gsub(s, what, with)
    return result
end

function string.contains(s, find)
    return string.find(s, find, 1, true) ~= nil
end

function string.matches(s, pattern)
    return string.match(s, pattern)
end

function string.length(s)
    return string.len(s)
end

function string.split(s, delimiter, max)
    if type(s) ~= "string" or s == "" then return {} end

    delimiter = delimiter or " "
    local result = {}
    local pattern = "(.-)"..delimiter:gsub("([^%w])", "%%%1")

    for part in string.gmatch(s, pattern) do
        table.insert(result, part)
        if max ~= nil and max - 1 > 0 then break end
    end

    local remainder = string.sub(s, #table.concat(result, delimiter) + #delimiter + 1)
    if remainder ~= "" then
        table.insert(result, remainder)
    end

    return result
end

function string.split2(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function string.trim(s)
    return string.match(s, "^%s*(.-)%s*$")
end

function string.at(s, index)
    return string.sub(s, index, index)
end
