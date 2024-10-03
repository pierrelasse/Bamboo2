local Scripting = classFor("net.bluept.scripting.Scripting")

local fs = require("@base/fs")


local classloader = {
}

---Adds a external .class file to the class loader.
---
---### Example
---```lua
---local classloader = require("@core/classloader")
----- Add class file to classloader
---classloader.addClassFile("@example", "example_MyCustomClass")
----- Load class
---local MyCustomClass = classFor("example_MyCustomClass")
----- Call method of class
---MyCustomClass.myMethodFromJava()
---```
---Java class location: ~/@example/example_MyCustomClass.class
---
---@param directory string
---@param className string
function classloader.addClassFile(directory, className)
    local classFile = fs.file(fs.file(fs.scriptingDir(), directory), className .. ".class")
    if classFile.isFile() then
        Scripting.INS.getScriptingClassLoader().addFile(className, classFile)
    end
end

function classloader.removeClass(className)
    Scripting.INS.getScriptingClassLoader().removeClass(className)
end

return classloader
