---@type vim.lsp.Config
return {
	cmd = { "bash-language-server", "start" },
	settings = {
		bashIde = { globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)" },
	},
	filetypes = { "bash", "sh" },
	single_file_support = true,
}
