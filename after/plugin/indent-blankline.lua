local icon = require("ui.icons").misc.indent

require("indent_blankline").setup({
	char = icon,
	show_current_context = true,
	show_current_context_start = true,
	space_char_blankline = " ",
})
