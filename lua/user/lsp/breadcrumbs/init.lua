---@class lsp.breadcrumbs
---@field winbar lsp.breadcrumbs.Winbar
---@field symbols lsp.breadcrumbs.Symbols
local M = {}

return setmetatable(M, {
	__index = function(_, key)
		return require("user.lsp.breadcrumbs." .. key)
	end,
})
