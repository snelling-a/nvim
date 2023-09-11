local labels = {
	"s",
	"f",
	"n",
	"u",
	"M",
	"Z",
}

--- @type LazySpec
local M = {
	"ggandor/leap.nvim",
}

M.opts = {
	labels = labels,
	safe_labels = labels,
}

return M
