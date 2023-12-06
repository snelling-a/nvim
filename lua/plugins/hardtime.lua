local Util = require("util")

---@type LazySpec
local M = { "m4xshen/hardtime.nvim" }

M.cond = Util.is_vim()

M.dependencies = {
	"MunifTanjim/nui.nvim",
	"nvim-lua/plenary.nvim",
}

M.event = { "FileLoaded" }

M.opts = {
	disabled_filetypes = vim.list_extend(Util.constants.no_format, { "qf" }),
	max_count = 10,
}

return M
