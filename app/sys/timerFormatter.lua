-- Von -1 bis 1
local offset = -1


---@param time integer
---@return string
return function(time)
    offset = offset + 0.1
    if offset > 1 then offset = -1 end

    local str = "<gradient:#707CF7:#F658CF:"..offset..">WWWWWWWWWWWWWW</gradient>"

    return str
end
