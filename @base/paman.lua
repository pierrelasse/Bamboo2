local System = classFor("java.lang.System")
local URL = classFor("java.net.URL")
local Util = classFor("net.bluept.scripting.Util")

local json = require("@base/json")
local fs = require("@base/fs")


local paman = {
    ---In millis
    fetchDelay = 10000
}
paman.__index = paman

local REMOTE_URL = "https://bluept.net/scripting"
local PACKAGES_FILE = fs.file(fs.scriptingDir(), "packages.json")

---@type table
local dremote
---@type table
local dlocal
---@type table
local processingLock = {}
---@type integer?
local lastCheck

local function getPackageDir(packageId) return fs.file(fs.scriptingDir(), "@"..packageId) end

local function decodeMPackageData(package)
    return {
        version = tonumber(package.ver),
        dependencies = package.dep,
        metadata = package.met,
        single = package.sin
    }
end

local function encodeMPackageData(package)
    return {
        ver = package.version,
        dep = package.dependencies,
        met = package.metadata,
        sin = package.single
    }
end

local function createConnection(url)
    url = URL(url)
    local conn = url.openConnection()
    conn.setRequestMethod("GET")
    conn.setConnectTimeout(2500)
    conn.setReadTimeout(2000)
    conn.setDoOutput(true)
    conn.setDoInput(true)
    conn.setUseCaches(false)
    conn.setRequestProperty("X-Paman-Version", "2")
    return conn
end

local function ensureLocal()
    if dlocal ~= nil then return end

    local data = {}

    if not PACKAGES_FILE.exists() then
        data.packages = {}
    else
        if not PACKAGES_FILE.isFile() then
            error("'"..PACKAGES_FILE.getAbsolutePath().."' is not a file")
        end

        local fileContent = fs.readFile(PACKAGES_FILE)
        local fileData = json.decode(fileContent)
        data.packages = {}
        for packageId, package in pairs(fileData.packages) do
            data.packages[packageId] = decodeMPackageData(package)
        end

        lastCheck = tonumber(fileData.lastCheck)
    end

    dlocal = data
end

local function exportLocal()
    if dlocal == nil then return end

    if PACKAGES_FILE.exists() and not PACKAGES_FILE.isFile() then
        error(PACKAGES_FILE.getAbsolutePath().." is not a file")
    end

    local data = {
        lastCheck = lastCheck,
        packages = {}
    }

    for packageId, package in pairs(dlocal.packages) do
        data.packages[packageId] = encodeMPackageData(package)
    end

    fs.writeFile(PACKAGES_FILE, json.encode(data))
end

local function ensureRemote()
    if dremote ~= nil then return end

    local function fetchRepo()
        local conn = createConnection(REMOTE_URL.."/repo")
        local data = Util.readStreamString(conn.getInputStream())
        return json.decode(data)
    end

    local packages = {}

    local success, repoData = pcall(fetchRepo)

    if not success then
        print("[paman] error while fetching repo data", repoData)
        return repoData
    end

    if repoData ~= nil then
        for packageId, package in pairs(repoData.packages) do
            packages[packageId] = decodeMPackageData(package)
        end
    end

    dremote = {
        packages = packages
    }
end

function paman.need(packageId)
    if processingLock[packageId] == true then return end
    processingLock[packageId] = true

    ensureLocal()

    local localPackage = dlocal.packages[packageId]
    if localPackage ~= nil and dremote == nil then
        local now = System.currentTimeMillis()
        if lastCheck ~= nil and now - lastCheck < paman.fetchDelay then
            return
        end
        lastCheck = now
        exportLocal()
    end

    local err = ensureRemote()
    if err ~= nil or dremote == nil then
        processingLock[packageId] = nil
        if localPackage == nil then
            error("error while fetching from remote: "..err)
        end
        return
    end

    local remotePackage = dremote.packages[packageId]
    if remotePackage == nil then
        processingLock[packageId] = nil
        if localPackage ~= nil then return end
        error("package '"..packageId.."' does not exist on remote")
    end

    if remotePackage.dependencies ~= nil then
        for _, dependency in ipairs(remotePackage.dependencies) do
            paman.need(dependency)
        end
    end

    if localPackage ~= nil and localPackage.version >= remotePackage.version then
        processingLock[packageId] = nil
        return
    end

    print("[paman] downloading "..packageId)

    local conn = createConnection(REMOTE_URL.."/downloadPackage?id="..packageId)

    local zipFile = fs.file(fs.scriptingDir(), "paman.tmp")

    fs.writeInputStreamToFile(conn.getInputStream(), zipFile)

    if remotePackage.single then
        local file = getPackageDir(packageId)
        local dir = file.getParentFile()
        if file.exists() then
            if file.isFile() then
                fs.remove(file)
            else
                error(fs.path(file).." is a directory. expected file")
            end
        end
        fs.extractZip(zipFile, dir)
    else
        fs.extractZip(zipFile, getPackageDir(packageId))
    end

    fs.remove(zipFile)

    dlocal.packages[packageId] = remotePackage
    exportLocal()

    processingLock[packageId] = nil
    return true
end

paman.need("base")

return paman
