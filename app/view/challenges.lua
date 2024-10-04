local screens = require("app/util/screens")


local function view(player, prevScreenFunc)
    local screen = screens.makeScreen("§lModifikationen", 9 * 1)

    screen:open(player)
end

return view
