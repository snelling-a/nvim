---@type LazySpec
local M = { "projekt0n/github-nvim-theme" }

-- M.lazy = false

M.opts = {
	options = {
		dim_inactive = true,
		hide_nc_statusline = false,
		inverse = {
			search = true,
		},
		styles = {
			comments = "italic",
			keywords = "italic",
			types = "bold",
		},
	},
}

-- M.priority = 1000

function M.config(_, opts)
	require("github-theme").setup(opts)
end

return M
