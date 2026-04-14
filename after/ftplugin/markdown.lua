if not vim.g.vscode then
	vim.cmd.packadd("markdown-plus.nvim")
	require("markdown-plus").setup()
	vim.cmd.packadd("markview.nvim")
end

vim.opt_local.wrap = true
vim.diagnostic.config({ underline = false }, vim.api.nvim_get_current_buf())
