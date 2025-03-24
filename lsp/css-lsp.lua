local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

---@type vim.lsp.Config
return {
	capabilities = capabilities,
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "less", "scss" },
	init_options = { provideFormatter = true },
	root_markers = { ".git", "package.json" },
	settings = {
		css = { validate = true },
		less = { validate = true },
		scss = { validate = true },
	},
	single_file_support = true,
}
