local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.cmd.packadd("SchemaStore.nvim")

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
	before_init = function(_, new_config)
		---@diagnostic disable-next-line: inject-field
		new_config.settings.json.schemas = new_config.settings.json.schemas or {}
		vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
	end,
}
