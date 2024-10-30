local Sidebar = require("@bukkit/scoreboard/Sidebar")
local simpleteams = require("@bukkit/scoreboard/simpleteams")


return function(player)
    local sb = Sidebar.get(player)

    sb:setTitle(bukkit.hex("§#DC0D6A§lTitle with HEX!!"))
    sb:setScores({
        bukkit.hex("§#E123E8").."§lLines with HEX!",
        bukkit.hex("§#7623E8").."§lLines with HEX!",
        bukkit.hex("§#2356E8").."§lLines with HEX!",
        bukkit.hex("§#23E828").."§lLines with HEX!",
        bukkit.hex("§#BCE823").."§lLines with HEX!",
        bukkit.hex("§#23E8B3").."§lLines with HEX!",
        bukkit.hex("§#E8B723").."§lLines with HEX!",
        bukkit.hex("§#E82323").."§lLines with HEX!",
    })

    simpleteams.getPlayerTeam(player, "A")
    simpleteams.setPlayerListName(player, bukkit.hex("§#EA5FD8").."[HELLO] "
        ..bukkit.hex("§#79ABEE")..player.getName()
        ..bukkit.hex("§#D3C979").." !!!")
    simpleteams.setNametagPrefix(player, bukkit.hex("§#78A89B").."[PREFIX] ")
    simpleteams.setNametagColor(player, "GREEN")
    simpleteams.setNametagSuffix(player, bukkit.hex("§#D87366").." \"Indian red\"")
end
