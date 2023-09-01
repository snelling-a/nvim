vim.opt_local.listchars = {
	space = " ",
}

require("config.util").nmap("<C-c>", ":cclose<CR>", { buffer = true, desc = "Close quickfix" })

