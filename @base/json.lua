--[[========
    Modified version of https://github.com/rxi/json.lua.
    License: https://github.com/rxi/json.lua/blob/master/LICENSE
]]

local json = {}

-- Encode

local encode

local escapeCharMap = {
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\b"] = "b",
    ["\f"] = "f",
    ["\n"] = "n",
    ["\r"] = "r",
    ["\t"] = "t",
}

local escapeCharMapInv = { ["/"] = "/" }
for k, v in pairs(escapeCharMap) do
    escapeCharMapInv[v] = k
end


local function escapeChar(c)
    return "\\"..(escapeCharMap[c] or string.format("u%04x", c:byte()))
end


local function encodeNil(val)
    return "null"
end

local function encodeTable(val, stack)
    local res = {}
    stack = stack or {}

    -- Circular reference?
    if stack[val] then error("circular reference") end

    stack[val] = true

    if rawget(val, 1) ~= nil or next(val) == nil then
        -- Treat as array -- check keys are valid and it is not sparse
        local n = 0
        for k in pairs(val) do
            if type(k) ~= "number" then
                error("invalid table: mixed or invalid key types")
            end
            n = n + 1
        end
        if n ~= #val then
            error("invalid table: sparse array")
        end
        -- Encode
        for _, v in ipairs(val) do
            table.insert(res, encode(v, stack))
        end
        stack[val] = nil
        return "["..table.concat(res, ",").."]"
    else
        -- Treat as an object
        for k, v in pairs(val) do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            table.insert(res, encode(k, stack)..":"..encode(v, stack))
        end
        stack[val] = nil
        return "{"..table.concat(res, ",").."}"
    end
end

local function encodeString(val)
    return '"'..val:gsub('[%z\1-\31\\"]', escapeChar)..'"'
end

local function encodeNumber(val)
    -- Check for NaN, -inf and inf
    if val ~= val or val <= -math.huge or val >= math.huge then
        error("unexpected number value '"..tostring(val).."'")
    end
    return tostring(val) --string.format("%.14g", val)
end


local typeEncoderMap = {
    ["nil"] = encodeNil,
    ["table"] = encodeTable,
    ["string"] = encodeString,
    ["number"] = encodeNumber,
    ["boolean"] = tostring,
}

encode = function(val, stack)
    local valType = type(val)
    local encoder = typeEncoderMap[valType]
    if encoder then
        return encoder(val, stack)
    end
    error("unexpected type '"..valType.."'")
end


function json.encode(val)
    return encode(val)
end

-- Decode

local parse

local function createSet(...)
    local res = {}
    for i = 1, select("#", ...) do
        res[select(i, ...)] = true
    end
    return res
end

local spaceChars  = createSet(" ", "\t", "\r", "\n")
local delimChars  = createSet(" ", "\t", "\r", "\n", "]", "}", ",")
local escapeChars = createSet("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals    = createSet("true", "false", "null")

local literalMap  = {
    ["true"] = true,
    ["false"] = false,
    ["null"] = nil,
}


local function nextChar(str, idx, set, negate)
    for i = idx, #str do
        if set[str:sub(i, i)] ~= negate then
            return i
        end
    end
    return #str + 1
end

local function decodeError(str, idx, msg)
    local line_count = 1
    local col_count = 1
    for i = 1, idx - 1 do
        col_count = col_count + 1
        if str:sub(i, i) == "\n" then
            line_count = line_count + 1
            col_count = 1
        end
    end
    error(string.format("%s at line %d col %d", msg, line_count, col_count))
end


local function codepointToUtf8(n)
    -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
    local f = math.floor
    if n <= 0x7f then
        return string.char(n)
    elseif n <= 0x7ff then
        return string.char(f(n / 64) + 192, n % 64 + 128)
    elseif n <= 0xffff then
        return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
    elseif n <= 0x10ffff then
        return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                           f(n % 4096 / 64) + 128, n % 64 + 128)
    end
    error(string.format("invalid unicode codepoint '%x'", n))
end


local function parse_unicode_escape(s)
    local n1 = tonumber(s:sub(1, 4), 16)
    local n2 = tonumber(s:sub(7, 10), 16)
    -- Surrogate pair?
    if n2 then
        return codepointToUtf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
    else
        return codepointToUtf8(n1)
    end
end


local function parseString(str, i)
    local res = ""
    local j = i + 1
    local k = j

    while j <= #str do
        local x = str:byte(j)

        if x < 32 then
            decodeError(str, j, "control character in string")
        elseif x == 92 then -- `\`: Escape
            res = res..str:sub(k, j - 1)
            j = j + 1
            local c = str:sub(j, j)
            if c == "u" then
                local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                    or str:match("^%x%x%x%x", j + 1)
                    or decodeError(str, j - 1, "invalid unicode escape in string")
                res = res..parse_unicode_escape(hex)
                j = j + #hex
            else
                if not escapeChars[c] then
                    decodeError(str, j - 1, "invalid escape char '"..c.."' in string")
                end
                res = res..escapeCharMapInv[c]
            end
            k = j + 1
        elseif x == 34 then -- `"`: End of string
            res = res..str:sub(k, j - 1)
            return res, j + 1
        end

        j = j + 1
    end

    decodeError(str, i, "expected closing quote for string")
end

local function parseNumber(str, i)
    local x = nextChar(str, i, delimChars)
    local s = str:sub(i, x - 1)
    local n = tonumber(s)
    if not n then
        decodeError(str, i, "invalid number '"..s.."'")
    end
    return n, x
end

local function parseLiteral(str, i)
    local x = nextChar(str, i, delimChars)
    local word = str:sub(i, x - 1)
    if not literals[word] then
        decodeError(str, i, "invalid literal '"..word.."'")
    end
    return literalMap[word], x
end

local function parseArray(str, i)
    local res = {}
    local n = 1
    i = i + 1
    while 1 do
        local x
        i = nextChar(str, i, spaceChars, true)
        -- Empty / end of array?
        if str:sub(i, i) == "]" then
            i = i + 1
            break
        end
        -- Read token
        x, i = parse(str, i)
        res[n] = x
        n = n + 1
        -- Next token
        i = nextChar(str, i, spaceChars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "]" then break end
        if chr ~= "," then decodeError(str, i, "expected ']' or ','") end
    end
    return res, i
end

local function parseObject(str, i)
    local res = {}
    i = i + 1
    while 1 do
        local key, val
        i = nextChar(str, i, spaceChars, true)
        -- Empty / end of object?
        if str:sub(i, i) == "}" then
            i = i + 1
            break
        end
        -- Read key
        if str:sub(i, i) ~= '"' then
            decodeError(str, i, "expected string for key")
        end
        key, i = parse(str, i)
        -- Read ':' delimiter
        i = nextChar(str, i, spaceChars, true)
        if str:sub(i, i) ~= ":" then
            decodeError(str, i, "expected ':' after key")
        end
        i = nextChar(str, i + 1, spaceChars, true)
        -- Read value
        val, i = parse(str, i)
        -- Set
        res[key] = val
        -- Next token
        i = nextChar(str, i, spaceChars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "}" then break end
        if chr ~= "," then decodeError(str, i, "expected '}' or ','") end
    end
    return res, i
end


local charParseMap = {
    ['"'] = parseString,
    ["0"] = parseNumber,
    ["1"] = parseNumber,
    ["2"] = parseNumber,
    ["3"] = parseNumber,
    ["4"] = parseNumber,
    ["5"] = parseNumber,
    ["6"] = parseNumber,
    ["7"] = parseNumber,
    ["8"] = parseNumber,
    ["9"] = parseNumber,
    ["-"] = parseNumber,
    ["t"] = parseLiteral,
    ["f"] = parseLiteral,
    ["n"] = parseLiteral,
    ["["] = parseArray,
    ["{"] = parseObject,
}

parse = function(str, idx)
    local char = str:sub(idx, idx)
    local decoder = charParseMap[char]
    if decoder then
        return decoder(str, idx)
    end
    decodeError(str, idx, "unexpected character '"..char.."'")
end


function json.decode(str)
    if type(str) ~= "string" then
        error("expected argument of type string, got "..type(str))
    end
    local res, idx = parse(str, nextChar(str, 1, spaceChars, true))
    idx = nextChar(str, idx, spaceChars, true)
    if idx <= #str then
        decodeError(str, idx, "trailing garbage")
    end
    return res
end

return json
