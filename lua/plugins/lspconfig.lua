local ensure_installed = require("config.lsp.util").ensure_installed
local javascript_typescript = require("config.util.constants").javascript_typescript

local M = {
	"neovim/nvim-lspconfig",
}

M.dependencies = {
	"dnlhc/glance.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"ibhagwan/fzf-lua",
	{
		"b0o/schemastore.nvim",
		ft = {
			"json",
			"jsonc",
			"yaml",
			"yml",
		},
	},
	{
		"folke/neodev.nvim",
		ft = {
			"lua",
		},
	},
	{
		"jparise/vim-graphql",
		ft = table.insert(javascript_typescript, "graphql"),
	},
}

M.event = "BufAdd"

function M.config()
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local opts = {
		capabilities = require("config.lsp.capabilities").get_capabilities(),
		flags = {
			debounce_text_changes = 150,
		},
		on_attach = require("config.lsp").on_attach,
	}

	ensure_installed(require("config.util.path").linters_formatters)

	local function cb(path) require(path).setup(opts) end

	ensure_installed(require("config.util.path").lsp_servers, cb)
end

return M
