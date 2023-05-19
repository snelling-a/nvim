local icon = require("config.ui.icons").misc.indent

local M = { "lukas-reineke/indent-blankline.nvim" }

M.cond = require("config.util").is_vim()

M.opts = {
	char = icon,
	context_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
	show_current_context = true,
	show_foldtext = true,
	space_char_blankline = " ",
	use_treesitter = false,
	use_treesitter_scope = false,
}

M.event = "BufReadPre"

return M
