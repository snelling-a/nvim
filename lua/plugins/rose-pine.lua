local M = {
	"rose-pine/neovim",
}

M.cmd = {
	"GenerateAverageColor",
}

-- M.lazy = false

M.name = "rose-pine"

M.opts = {
	bold_vert_split = true,
	dim_nc_background = true,
}

-- M.priority = 1000

function M.config(_, opts)
	require("rose-pine").setup(opts)

	-- vim.cmd.colorscheme("rose-pine")
end

return M
