---@type LazySpec
local M = { "ruifm/gitlinker.nvim" }

M.config = true

M.dependencies = { "nvim-lua/plenary.nvim" }

M.keys = {
	{
		"<leader>gy",
		mode = { "n", "v" },
		desc = "[G]et remote url for current buffer",
	},
}

return M
