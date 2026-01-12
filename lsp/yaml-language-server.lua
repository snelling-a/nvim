vim.cmd.packadd("SchemaStore.nvim")

---@type vim.lsp.Config
return {
	before_init = function(_, new_config)
		---@diagnostic disable-next-line: inject-field
		new_config.settings.yaml.schemas =
			vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
	end,
	capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } },
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	on_init = function(client)
		---@diagnostic disable-next-line: inject-field
		client.settings.yaml.schemas =
			vim.tbl_deep_extend("force", client.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
	end,
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			keyOrdering = false,
			format = { enable = true },
			validate = true,
			schemaStore = { enable = false, url = "" },
		},
	},
}
