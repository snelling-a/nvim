---@type vim.lsp.Config
return {
	capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } },
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	on_init = function(client)
		---@diagnostic disable-next-line: inject-field
		client.settings.yaml.schemas =
			vim.tbl_deep_extend("force", client.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
	end,
	root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			keyOrdering = false,
			format = { enable = true },
			validate = true,
			schemaStore = { enable = false, url = "" },
		},
	},
	single_file_support = true,
}
