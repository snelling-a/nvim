if not vim.g.vscode then
	vim.cmd.packadd("markdown-preview.nvim")
	vim.cmd.packadd("markdown-plus.nvim")
	require("markdown-plus").setup()
	vim.cmd.packadd("markview.nvim")
end
