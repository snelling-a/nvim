--- @type LazySpec
local M = {
	"ray-x/lsp_signature.nvim",
}

M.event = {
	"LspAttach",
}

M.opts = {
	bind = true,
	floating_window = false,
	hint_enable = true,
	hint_prefix = require("config.ui.icons").misc.panda,
	hint_scheme = "TSComment",
}

return M
