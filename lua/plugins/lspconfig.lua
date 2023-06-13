local javascript_typescript = require("config.util.constants").javascript_typescript

local LspConfig = { "neovim/nvim-lspconfig" }

LspConfig.dependencies = {
	"dnlhc/glance.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"ibhagwan/fzf-lua",
	"lvimuser/lsp-inlayhints.nvim",
	{ "b0o/schemastore.nvim", ft = { "json", "jsonc", "yaml", "yml" } },
	{ "folke/neodev.nvim", ft = { "lua" } },
	{ "jparise/vim-graphql", ft = table.insert(javascript_typescript, "graphql") },
	{ "yioneko/nvim-vtsls", ft = javascript_typescript },
}

LspConfig.event = "BufAdd"

function LspConfig.config()
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

return LspConfig
