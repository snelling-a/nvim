---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		yamlls = {
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
			on_new_config = function(new_config)
				new_config.settings.yaml.schemas = vim.tbl_deep_extend(
					"force",
					new_config.settings.yaml.schemas or {},
					require("schemastore").yaml.schemas()
				)
			end,
			settings = {
				redhat = {
					telemetry = { enabled = false },
				},
				yaml = {
					keyOrdering = false,
					format = {
						enable = true,
					},
					validate = true,
					schemaStore = {
						enable = false,
						url = "",
					},
				},
			},
		},
	},
	setup = {
		yamlls = function()
			if vim.fn.has("nvim-0.10") == 0 then
				require("lsp").on_attach(function(client, _)
					if client.name == "yamlls" then
						client.server_capabilities.documentFormattingProvider = true
					end
				end)
			end
		end,
	},
}

local language_setup = require("lsp.util").setup_language({
	langs = { "yaml" },
	linters = { "yamllint" },
	formatters = { "yamlfmt" },
})

return {
	M,
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false,
	},
	unpack(language_setup),
}
