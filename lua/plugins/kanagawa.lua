--- @type LazySpec
local M = {
	"rebelot/kanagawa.nvim",
}

M.cmd = {
	"GenerateAverageColor",
}

-- M.lazy = false

M.opts = {
	background = {
		dark = "dragon",
	},
	compile = true,
	dimInactive = true,
	theme = "dragon",
}

-- M.priority = 1000

function M.config(_, opts)
	require("kanagawa").setup(opts)

	-- vim.cmd.colorscheme("kanagawa-dragon")
end

return M
