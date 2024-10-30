local paman = require("@base/paman")
paman.need("bukkit/guimaker")
paman.need("bukkit/scoreboard/Sidebar")
paman.need("bukkit/scoreboard/simpleteams")
paman.need("bukkit/worldmanager")
paman.need("bukkit/basic")
paman.need("core/classloader")

require("@bukkit/basic")

require("app/util/static")
require("app/i18n")

require("app/sys/chat")
require("app/sys/fastreset")
require("app/sys/joinQuitMsgs")
require("app/sys/menu")
require("app/sys/messaging")
require("app/sys/resetCommand")
require("app/sys/staff")
require("app/sys/timerTranslations")
require("app/sys/timer")
require("app/sys/timerCommand")
require("app/sys/timerDisplay")

require("app/service/serviceManager").load()
require("app/service/command")

require("app/dev/index")

require("app/admincommands/_all")

paman.need("bukkit/plugins/eval")
require("@bukkit/plugins/eval")

paman.need("bukkit/plugins/itemEdit")
require("@bukkit/plugins/itemEdit")
