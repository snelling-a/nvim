local Icons = require("config.ui.icons").fillchars

local M = { "dnlhc/glance.nvim" }

M.event = "LspAttach"

M.keys = {
	{
		"gd",
		function() vim.cmd.Glance("definitions") end,
		desc = "[G]lance at [d]efinition",
	},
	{
		"gr",
		function() vim.cmd.Glance("references") end,
		desc = "[G]lance at [r]eferences",
	},
	{
		"gy",
		function() vim.cmd.Glance("type_definitions") end,
		desc = "[G]lance at t[y]pe definition",
	},
	{
		"gi",
		function() vim.cmd.Glance("implementations") end,
		desc = "[G]lance at [i]mplementations",
	},
}

M.opts = {
	preview_win_opts = { wrap = false },
	folds = { fold_closed = Icons.foldclose, fold_open = Icons.foldopen },
	indent_lines = { icon = Icons.foldsep },
}

return M
