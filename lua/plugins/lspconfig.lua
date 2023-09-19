local ensure_installed = require("config.lsp.util").ensure_installed
local javascript_typescript = require("config.util.constants").javascript_typescript

--- @type LazySpec
local M = {
	"neovim/nvim-lspconfig",
}

M.dependencies = {
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
		opts = {
			library = {
				types = false,
			},
		},
	},
	{
		"jparise/vim-graphql",
		ft = require("config.util").tbl_extend_force(javascript_typescript, {
			"graphql",
		}),
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
