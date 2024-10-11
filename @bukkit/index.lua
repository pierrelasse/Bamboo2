---@diagnostic disable-next-line: lowercase-global
bukkit = {
    Bukkit = classFor("org.bukkit.Bukkit")
}

if bukkit.Bukkit == nil then
    error("bukkit class not found. are you running bukkit?")
end

return bukkit
