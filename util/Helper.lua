---@meta

---@class pierrelasse.bamboo.Helper
local Helper = {}

---@param codePoint integer
---@return string
function Helper.stringFromCodePoint(codePoint) end

---@param s string
---@return integer
function Helper.codePointFromString(s) end

local classloader = require("@core/classloader")
classloader.addClassFile("@pierrelasse/bamboo", "pierrelasse_bamboo_Helper")

---@type pierrelasse.bamboo.Helper
Bamboo.Helper = classFor("pierrelasse_bamboo_Helper")
