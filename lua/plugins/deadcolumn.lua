--- @type LazySpec
local M = {
	"Bekaboo/deadcolumn.nvim",
}

M.event = require("config.util.constants").lazy_event

M.opts = {
	blending = {
		threshold = 0.90,
	},
	warning = {
		offset = 5,
	},
}

return M
