---@class Config
---@field autocmd user.Autocmd
---@field keymap user.Keymap
---@field lsp user.Lsp
---@field icons user.Icons
---@field util user.Util
local M = {}

function M.setup()
	require("user.opt")
	require("user.keymap")
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
