--- @type LazySpec
local M = {
	"vigoux/notifier.nvim",
}

M.event = {
	"BufAdd",
}

M.opts = {
	components = {
		"nvim",
		"lsp",
		"mason",
		"treesitter",
	},
}

return M
