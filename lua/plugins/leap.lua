local labels = {
	"m",
	"M",
	"z",
	"Z",
}

--- @type LazySpec
local M = {
	"ggandor/leap.nvim",
}

M.event = require("config.util.constants").lazy_event

M.opts = {
	labels = labels,
	safe_labels = labels,
}

return M
