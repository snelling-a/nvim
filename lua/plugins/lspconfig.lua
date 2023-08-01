local javascript_typescript = require("config.util.constants").javascript_typescript

local LspConfig = { "neovim/nvim-lspconfig" }

LspConfig.dependencies = {
	"dnlhc/glance.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"ibhagwan/fzf-lua",
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

	local function cb(path) require(path).setup(opts) end
	local target_dir = require("config.util.path").lsp_servers

	require("config.lsp.util").ensure_installed(target_dir, cb)
end

return LspConfig
