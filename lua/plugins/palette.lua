--- @type LazySpec
local M = {
	"roobert/palette.nvim",
}

M.cmd = {
	"GenerateAverageColor",
}

-- M.lazy = false

M.opts = {
	palettes = {
		main = "dark",
		accent = "pastel",
		state = "pastel",
	},
	italics = true,
}

-- M.priority = 1000

function M.config(_, opts)
	require("palette").setup(opts)

	-- vim.cmd.colorscheme("palette")
end

return M
