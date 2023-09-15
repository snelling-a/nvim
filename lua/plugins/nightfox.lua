--- @type LazySpec
local M = {
	"EdenEast/nightfox.nvim",
}

M.cmd = "GenerateAverageColor"

-- M.lazy = false

M.opts = {
	dim_inactive = true,
	inverse = {
		search = true,
	},
}

-- M.priority = 1000

function M.config(_, opts)
	require("nightfox").setup(opts)

	-- vim.cmd.colorscheme("carbonfox")
end

return M
