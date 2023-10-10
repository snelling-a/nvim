--- @type LazySpec
local M = {
	"windwp/nvim-autopairs",
}

M.opts = {
	check_ts = true,
	map_cr = false,
}

M.event = {
	"InsertEnter",
}

return M
