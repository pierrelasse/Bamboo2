local chatInput = require("@pierrelasse/bamboo/util/chatInput")

return function(sender)
    local a = math.random(1, 20)
    local b = math.random(1, 20)
    local op
    local result
    if math.random(0, 1) == 0 then
        op = "+"
        result = a + b
    elseif math.random(0, 1) == 0 then
        op = "*"
        result = a * b
    elseif math.random(0, 1) == 0 then
        op = "^"
        result = a ^ b
    else
        op = "-"
        result = a - b
    end
    result = tostring(result)

    local id = chatInput.exec(sender, {
        timeout = 20 * 5,
        accept = function(message)
            if message == result then
                bukkit.send(sender, "§aCorrect!!")
                return true
            else
                bukkit.send(sender, "§cFail! Try again")
            end
        end,
        cancel = function(reason)
            if reason == "timeout" then
                bukkit.send(sender, "§cDidn't got it in time! >:(")
            end
        end
    })
    if id ~= nil then
        bukkit.send(sender, "§7What is §e"..a.." "..op.." ".." "..b.."§7? You have 5 seconds.")
    else
        bukkit.send(sender, "§cAlready running")
    end
end
