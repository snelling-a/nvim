local icons = require("config.ui.icons")

local M = { "neovim/nvim-lspconfig" }

M.dependencies = {
	"b0o/schemastore.nvim",
	"folke/neodev.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"ibhagwan/fzf-lua",
	"jparise/vim-graphql",
	"lvimuser/lsp-inlayhints.nvim",
	"SmiteshP/nvim-navic",
	{ "yioneko/nvim-vtsls", ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" } },
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = icons.done,
					package_pending = icons.pending,
					package_uninstalled = icons.trash,
				},
			},
		},
	},
	{ "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
}

function M.config()
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local opts = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		flags = { debounce_text_changes = 150 },
		on_attach = require("config.lsp").on_attach,
	}

	for index, value in vim.fs.dir("$XDG_CONFIG_HOME/neovim/lua/config/lsp/server") do
		if value ~= "file" then
			return
		end

		require("config.lsp.server." .. index:gsub(".lua", "")).setup(opts)
	end
end

return M
