local paman = require("@base/paman")
paman.need("core")
paman.need("extra/guimaker")
paman.need("extra/bukkitVersion")
paman.need("core/classloader")
paman.need("worldmanager")

require("@core/util/string")
require("@core/util/table")

require("app/util/util")

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

require("app/challenge/challengeManager").loadChallenges()
require("app/challenge/testcmd")

require("app/dev/index")

require("app/util/itemEdit")
