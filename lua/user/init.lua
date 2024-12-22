---@class Config
---@field icons user.Icons
local M = {}
function M.setup()
	require("user.opt")
end

return setmetatable(M, {
	__index = function(t, k)
		---@type table
		t[k] = require("user." .. k)

		return t[k]
	end,
	__call = function() end,
})
