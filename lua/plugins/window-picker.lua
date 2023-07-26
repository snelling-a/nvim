local highlights = {
	focused = {
		fg = vim.g.base05,
		bg = vim.g.base09,
		bold = true,
	},
	unfocused = {
		fg = vim.g.base04,
		bg = vim.g.base08,
		bold = true,
	},
}

local WindowPicker = { "s1n7ax/nvim-window-picker" }

WindowPicker.ft = "neo-tree"

WindowPicker.opts = {
	autoselect_one = true,
	filter_rules = {
		bo = { buftype = { "terminal", "quickfix", "nofile" }, filetype = { "neo-tree", "neo-tree-popup", "notify" } },
	},
	hint = "floating-big-letter",
	highlights = { statusline = highlights, winbar = highlights },
}

return WindowPicker
