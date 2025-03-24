---@type vim.lsp.Config
return {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = {
		"css",
		"eruby",
		"html",
		"htmlangular",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"typescriptreact",
	},
	single_file_support = true,
}
