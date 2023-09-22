--- @type LazySpec
local M = {
	"Bekaboo/deadcolumn.nvim",
}

M.event = {
	"BufAdd",
}

M.opts = {
	blending = {
		threshold = 0.90,
	},
	warning = {
		offset = 5,
	},
}

return M
