---@type LazySpec
local M = { "echasnovski/mini.pairs" }

M.event = { "InsertEnter" }

function M.config(_, opts)
	require("mini.pairs").setup(opts)

	require("keymap").nmap("<leader>tp", function()
		local Logger = require("util").logger
		vim.g.minipairs_disable = not vim.g.minipairs_disable
		if vim.g.minipairs_disable then
			Logger:warn("Disabled auto pairs")
		else
			Logger:info("Enabled auto pairs")
		end
	end, { desc = "Toggle auto pairs" })
end

return M
