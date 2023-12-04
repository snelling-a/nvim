---@type LazySpec
local M = { "chrishrb/gx.nvim" }

M.config = true

M.dependencies = { "nvim-lua/plenary.nvim" }

M.keys = {
	"gx",
	mode = { "n", "v" },
	desc = "Better [gx]",
}

M.opts = {
	handler_options = { search_engine = "ecosia" },
}

return M
