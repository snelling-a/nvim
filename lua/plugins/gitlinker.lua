--- @type LazySpec
local M = {
	"ruifm/gitlinker.nvim",
}

M.config = true

M.dependencies = {
	"nvim-lua/plenary.nvim",
}

M.event = {
	"BufAdd",
}

return M
