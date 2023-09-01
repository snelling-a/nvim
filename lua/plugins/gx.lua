--- @type LazySpec
local M = {
	"chrishrb/gx.nvim",
}

M.config = true

M.dependencies = {
	"nvim-lua/plenary.nvim",
}

M.event = {
	"BufEnter",
}

M.opts = {
	handler_options = {
		search_engine = "ecosia",
	},
}

return M
