---@type LazySpec
local M = { "rose-pine/neovim" }

-- M.lazy = false

M.name = "rose-pine"

---@type RosePineOptions
M.opts = {
	variant = "moon",
	bold_vert_split = true,
	dim_nc_background = true,
}

-- M.priority = 1000

function M.config(_, opts)
	require("rose-pine").setup(opts)
end

return M
