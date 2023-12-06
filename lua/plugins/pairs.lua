local M = { "echasnovski/mini.pairs" }

M.event = "FileLoaded"

M.keys = {
	{
		"<leader>up",
		function()
			local Logger = require("util").logger
			vim.g.minipairs_disable = not vim.g.minipairs_disable
			if vim.g.minipairs_disable then
				Logger:warn("Disabled auto pairs")
			else
				Logger:info("Enabled auto pairs")
			end
		end,
		desc = "Toggle auto pairs",
	},
}

M.opts = {}

return M
