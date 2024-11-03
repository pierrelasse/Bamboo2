local paman = require("@base/paman")
paman.need("bukkit/basic")
paman.need("bukkit/guimaker")
paman.need("bukkit/scoreboard/Sidebar")
paman.need("bukkit/scoreboard/simpleteams")
paman.need("bukkit/worldmanager")
paman.need("core/classloader")

require("@bukkit/basic")

-- Bamboo
do
    Bamboo = {}

    require("@pierrelasse/bamboo/util/Helper")

    require("@pierrelasse/bamboo/util/logger")

    Bamboo._debugLogger = Bamboo.logger("debug")
    function Bamboo.debug(message)
        Bamboo._debugLogger:debug(message)
    end

    require("@pierrelasse/bamboo/util/static")

    require("@pierrelasse/bamboo/lang/index")

    require("@pierrelasse/bamboo/sys/timer")
    require("@pierrelasse/bamboo/sys/timerCommand")

    require("@pierrelasse/bamboo/sys/fastreset")

    require("@pierrelasse/bamboo/service/serviceManager")
    require("@pierrelasse/bamboo/service/command")

    require("@pierrelasse/bamboo/dev/index")

    require("@pierrelasse/bamboo/sys/lagprot")

    Bamboo.timer.load()
    Bamboo.serviceManager.load()
end

-- Util
require("@pierrelasse/bamboo/admincommands/_all")

paman.need("bukkit/plugins/eval")
require("@bukkit/plugins/eval")

paman.need("bukkit/plugins/itemEdit")
require("@bukkit/plugins/itemEdit")
