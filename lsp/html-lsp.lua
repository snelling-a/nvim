local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

---@type vim.lsp.Config
return {
	capabilities = capabilities,
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "xhtml", "mjml", "templ" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
		provideFormatter = true,
	},
	root_markers = { "package.json", ".git" },
	settings = {
		html = {
			hover = { documentation = true, references = true },
		},
	},
	single_file_support = true,
}
