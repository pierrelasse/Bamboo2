require("@base/paman").needs(
    "bukkit/api",
    "bukkit/worldmanager"
)

Bamboo = {}

require("@pierrelasse/bamboo/util/Helper")

require("@pierrelasse/bamboo/util/logger")

Bamboo._debugLogger = Bamboo.logger("debug")
function Bamboo.debug(message)
    Bamboo._debugLogger:debug(message)
end

require("@pierrelasse/bamboo/lang/")

require("@pierrelasse/bamboo/sys/timer")
require("@pierrelasse/bamboo/sys/timerCommand")

require("@pierrelasse/bamboo/service/serviceManager")
require("@pierrelasse/bamboo/service/command")

Bamboo.timer.load()
Bamboo.serviceManager.load()

require("@pierrelasse/bamboo/sys/fastreset")

-- require("@pierrelasse/bamboo/util/chatInput")
