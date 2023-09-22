--- @type LazySpec
local M = {
	"lmburns/lf.nvim",
}

M.cmd = {
	"Lf",
}

M.dependencies = {
	"nvim-lua/plenary.nvim",
	"akinsho/toggleterm.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<M-o>",
		vim.cmd.Lf,
		desc = "Open lf",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<M-u",
		desc = "Resize lf window",
	},
}

M.opts = {
	default_actions = {
		["<C-s>"] = "split",
	},
}

return M
