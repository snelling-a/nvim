local M = { "anuvyklack/pretty-fold.nvim" }

M.event = { "BufReadPost", "BufNewFile" }

M.dependencies = {
	{
		"anuvyklack/fold-preview.nvim",
		dependencies = { "anuvyklack/keymap-amend.nvim" },
		opts = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
	},
}

M.opts = {
	keep_indentation = false,
	fill_char = "━",
	sections = {
		left = { "━ ", function() return string.rep("*", vim.v.foldlevel) end, " ━┫", "content", "┣", },
		right = { "┫ ", "number_of_folded_lines", ": ", "percentage", " ┣━━", }, },
}

return M
