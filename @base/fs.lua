local Scripting = classFor("net.bluept.scripting.Scripting")
local Util = classFor("net.bluept.scripting.Util")
local File = classFor("java.io.File")
local FileInputStream = classFor("java.io.FileInputStream")
local FileOutputStream = classFor("java.io.FileOutputStream")


local fs = {}

---Creates a java.io.File from a path
---
---Usages:
---```
---fs.file(pathname: string)
---fs.file(parent: string, child: string)
---fs.file(parent: File, child: string)
---fs.file(uri: URI)
---```
fs.file = File

---Deletes a file or directory
---@param file JavaObject java.io.File
---@param recursive boolean? true by default
function fs.remove(file, recursive)
    if file.isDirectory() then
        if recursive == false then return false end
        local files = file.listFiles()
        if files ~= nil then
            for subFile in forEach(files) do
                if not fs.remove(subFile) then return false end
            end
        end
    end
    return file.delete() == true
end

---Reads the content of a file
---@param file JavaObject java.io.File
---@return string content of the file
function fs.readFile(file)
    return Util.readStreamString(FileInputStream(file))
end

---Writes data to a file
---@param file JavaObject java.io.File
---@param data string Data to write
function fs.writeFile(file, data)
    Util.writeStreamOnce(FileOutputStream(file), data)
end

function fs.writeInputStreamToFile(inputStream, file)
    Util.transferStream(inputStream, FileOutputStream(file))
end

---Extracts the content of a zip into a directory
---@param zipFile JavaObject java.io.File
---@param targetDir JavaObject java.io.File
function fs.extractZip(zipFile, targetDir)
    Util.extractZip(zipFile, targetDir)
end

---
---@param from JavaObject java.io.File
---@param to JavaObject java.io.File
---@return boolean success
function fs.copy(from, to)
    return Util.copy(from, to)
end

---Gets the absolute path of a file
---@param file JavaObject java.io.File
---@return string
function fs.path(file)
    return Util.filePath(file)
end

---Deletes a file or directory on program exit
---@param path string
function fs.deleteOnExit(path)
    Util.deleteOnExit(path)
end

---
---@return JavaObject dir java.io.File
function fs.scriptingDir()
    return Scripting.INS.SCRIPTING_FOLDER
end

return fs
