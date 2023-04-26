local icon = require("ui.icons").misc.indent

require("indent_blankline").setup({
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
	use_treesitter = true,
	use_treesitter_scope = true,
})
