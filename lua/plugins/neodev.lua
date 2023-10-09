--- @type LazySpec
local M = {
	"folke/neodev.nvim",
}
M.opts = {
	library = {
		plugins = {
			"nvim-dap-ui",
		},
		types = true,
	},
}

M.ft = {
	"lua",
}

return M
