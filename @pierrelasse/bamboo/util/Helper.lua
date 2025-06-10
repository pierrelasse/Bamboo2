---@meta

---@class pierrelasse.bamboo.Helper
local Helper = {}

---@param codePoint integer
---@return string
function Helper.stringFromCodePoint(codePoint) end

---@param s string
---@return integer
function Helper.codePointFromString(s) end

---@param s string
---@param what string
---@param with string
---@return string
function Helper.stringReplace(s, what, with) end

---@param hash string
---@return JavaObject
function Helper.sha1FromStr(hash) end

classloader.addClassFile("@pierrelasse/bamboo", "pierrelasse_bamboo_Helper")

---@type pierrelasse.bamboo.Helper
---@diagnostic disable-next-line: assign-type-mismatch
Bamboo.Helper = import("pierrelasse_bamboo_Helper")
