local PrettyFold = {
	"anuvyklack/pretty-fold.nvim",
}

PrettyFold.event = {
	"BufReadPost",
	"BufNewFile",
}

PrettyFold.dependencies = {
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

PrettyFold.opts = {
	keep_indentation = false,
	fill_char = "━",
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

return PrettyFold
