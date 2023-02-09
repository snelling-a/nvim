require("base16-colorscheme").with_config({
	telescope = true,
	indentblankline = true,
	notify = true,
	ts_rainbow = true,
	cmp = true,
	illuminate = true,
})

vim.cmd.colorscheme("base16-default-dark")

local color = require("base16-colorscheme").colors.base02

vim.cmd.highlight({ "LspReferenceRead", "gui=NONE", "guibg=" .. color })
vim.cmd.highlight({ "LspReferenceText", "gui=NONE", "guibg=" .. color })
vim.cmd.highlight({ "LspReferenceWrite", "gui=NONE", "guibg=" .. color })
