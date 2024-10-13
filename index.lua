local paman = require("@base/paman")
paman.need("bukkit/worldmanager")
paman.need("bukkit/getPlayer")
paman.need("bukkit/onlinePlayers")
paman.need("bukkit/send")
paman.need("core/classloader")
paman.need("extra/guimaker")

require("@core/util/string")
require("@core/util/table")

require("@bukkit/getPlayer")
require("@bukkit/onlinePlayers")
require("@bukkit/send")

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

require("app/util/itemEdit")
