vim.bo.syntax = "typescriptreact"

vim.cmd.runtime({
	args = { "ftplugin/typescriptreact.lua" },
	bang = true,
})

vim.cmd.runtime({
	args = { "ftplugin/javascript.lua" },
	bang = true,
})
