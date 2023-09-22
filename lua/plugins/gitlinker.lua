--- @type LazySpec
local M = {
	"ruifm/gitlinker.nvim",
}

M.config = true

M.dependencies = {
	"nvim-lua/plenary.nvim",
}

M.event = require("config.util.constants").lazy_event

return M
