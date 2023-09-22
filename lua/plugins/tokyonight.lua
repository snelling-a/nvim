--- @type LazySpec
local M = {
	"folke/tokyonight.nvim",
}

M.cmd = {
	"GenerateAverageColor",
}

-- M.lazy = false

M.opts = {
	style = "night",
	dim_inactive = true,
}

-- M.priority = 1000

-- M.priority = 1000

function M.config(_, opts)
	require("tokyonight").setup(opts)

	-- vim.cmd.colorscheme("tokyonight")
end

return M
