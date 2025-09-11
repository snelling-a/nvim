---@type vim.lsp.Config
return {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	single_file_support = true,
	settings = {
		taplo = {
			configFile = { enabled = true },
			schema = {
				enabled = true,
				catalogs = { "https://www.schemastore.org/api/json/catalog.json" },
				cache = {
					memoryExpiration = 60,
					diskExpiration = 600,
				},
			},
		},
	},
}
