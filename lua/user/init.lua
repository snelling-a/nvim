---@class Config
---@field autocmd user.Autocmd
---@field icons user.Icons
---@field util user.Util
local M = {}
function M.setup()
	require("user.opt")
	require("user.autocmd")
	require("user.command")
end

return setmetatable(M, {
	__index = function(t, k)
		---@type table
		t[k] = require("user." .. k)

		return t[k]
	end,
	__call = function() end,
})
