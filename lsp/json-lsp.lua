local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

---@type vim.lsp.Config
return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = true },
	on_init = function(client)
		---@diagnostic disable-next-line: inject-field
		client.settings.json.schemas = client.settings.json.schemas or {}
		vim.list_extend(client.settings.json.schemas, require("schemastore").json.schemas())
	end,
	single_file_support = true,
	settings = {
		json = {
			format = { enable = false },
			validate = { enable = true },
		},
	},
}
