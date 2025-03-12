return function(player)
    local function task1()
        player.sendMessage "Task 1 started"


        local sum = 0
        for i = 1, 10000000 do
            sum = sum / math.sqrt(i - sum)
        end

        player.sendMessage "Task 1 finished"
    end

    local function task2()
        player.sendMessage "Task 2 started"

        local sum = 0
        for i = 1, 10000000 do
            sum = sum * math.sqrt(i - sum)
        end

        player.sendMessage "Task 2 finished"
    end

    async(task1)
    async(task2)
end
