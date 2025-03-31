local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

---@type vim.lsp.Config
return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		json = {
			format = { enable = false },
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
