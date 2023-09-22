local M = {
	"anuvyklack/pretty-fold.nvim",
}

M.event = {
	"BufReadPost",
	"BufNewFile",
}

M.dependencies = {
	{
		"anuvyklack/fold-preview.nvim",
		dependencies = {
			"anuvyklack/keymap-amend.nvim",
		},
		opts = {
			border = "rounded",
		},
	},
}

M.opts = {
	keep_indentation = false,
	fill_char = "━",
	ft_ignore = require("config.util.constants").no_format,
	sections = {
		left = {
			"━ ",
			function() return string.rep("*", vim.v.foldlevel) end,
			" ━┫",
			"content",
			"┣",
		},
		right = {
			"┫ ",
			"number_of_folded_lines",
			": ",
			"percentage",
			" ┣━━",
		},
	},
}

return M
