vim.opt_local.listchars = {
	space = " ",
}

require("config.util").nmap("<C-c>", function() vim.cmd.cclose() end, {
	buffer = true,
	desc = "Close quickfix",
})
