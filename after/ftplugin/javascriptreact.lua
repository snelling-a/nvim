vim.bo.syntax = "typescriptreact"

vim.cmd.runtime({
	args = { "ftplugin/typescriptreact.lua" },
	bang = true,
})
