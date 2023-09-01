--- @type LazySpec
local M = {
	"Bekaboo/deadcolumn.nvim",
}

M.event = "BufAdd"

M.opts = {
	blending = {
		hlgroup = {
			"ColorColumn",
			"background",
		},
		threshold = 0,
	},
	warning = {
		colorcode = vim.g.base08,
	},
}

return M
