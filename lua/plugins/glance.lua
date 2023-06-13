local icons = require("config.ui.icons").fillchars

local Glance = { "dnlhc/glance.nvim" }

Glance.event = "LspAttach"

Glance.keys = {
	{ "gd", function() vim.cmd.Glance("definitions") end, desc = "Show [d]efinition" },
	{ "gr", function() vim.cmd.Glance("references") end, desc = "[G]et [r]eferences" },
	{ "gy", function() vim.cmd.Glance("type_definitions") end, desc = "Show t[y]pe definition" },
	{ "gi", function() vim.cmd.Glance("implementations") end, desc = "" },
}

Glance.opts = {
	preview_win_opts = { wrap = false },
	folds = { fold_closed = icons.foldclose, fold_open = icons.foldopen },
	indent_lines = { icon = icons.foldsep },
}

return Glance
