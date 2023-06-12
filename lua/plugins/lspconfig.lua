local M = { "neovim/nvim-lspconfig" }

M.dependencies = {
	"b0o/schemastore.nvim",
	"folke/neodev.nvim",
	"hrsh7th/cmp-nvim-lsp",
	-- "ibhagwan/fzf-lua",
	"jparise/vim-graphql",
	"lvimuser/lsp-inlayhints.nvim",
	"yioneko/nvim-vtsls",
}

function M.config()
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local opts = {
		capabilities = require("config.lsp.capabilities").get_capabilities(),
		flags = { debounce_text_changes = 150 },
		on_attach = require("config.lsp").on_attach,
	}

	for index, value in vim.fs.dir("$XDG_CONFIG_HOME/nvim/lua/config/lsp/server") do
		if value ~= "file" then
			return
		end

		require("config.lsp.server." .. index:gsub(".lua", "")).setup(opts)
	end
end

return M
