---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.dependencies = { "b0o/SchemaStore.nvim", lazy = true, version = false }

M.opts = {
	servers = {
		jsonls = {
			on_new_config = function(new_config)
				new_config.settings.json.schemas = new_config.settings.json.schemas or {}
				vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
			end,
			settings = {
				json = {
					format = {
						enable = true,
					},
					validate = { enable = true },
				},
			},
		},
	},
}

local languge_setup = require("lsp").util.setup_language({
	langs = { "json", "json5", "jsonc" },
	formatters = { "prettierd" },
})

return {
	M,
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft.json = { "jq" }
		end,
	},
	unpack(languge_setup),
}
