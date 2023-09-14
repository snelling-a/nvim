--- @type LazySpec
local M = {
	"ruifm/gitlinker.nvim",
}

M.dependencies = {
	"nvim-lua/plenary.nvim",
}

M.event = "BufAdd"

return M
