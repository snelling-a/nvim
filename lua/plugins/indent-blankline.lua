local M = { "lukas-reineke/indent-blankline.nvim" }

M.cond = require("config.util").is_vim()

local context_highlight_list = {}
for i = 1, 6, 1 do
	context_highlight_list[i] = "IndentBlanklineIndent" .. tostring(i)
end

M.opts = {
	char = require("config.ui.icons").fillchars.foldsep,
	context_highlight_list = context_highlight_list,
	filetype_exclude = require("config.util.constants").no_format,
	show_current_context = true,
	show_foldtext = true,
	space_char_blankline = " ",
	use_treesitter = false,
	use_treesitter_scope = false,
}

M.event = "BufReadPre"

return M
