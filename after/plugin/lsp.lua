local lsp_config = require("lsp_config")
local lspconfig = require("lspconfig")
local utils = require("utils")

require("neodev").setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig.ui.windows").default_options.border = "rounded"

lsp_config.setup()

local options = {
	on_attach = lsp_config.on_attach,
	capabilities = capabilities,
	lsp_flags = { debounce_text_changes = 150 },
}

local servers = lsp_config.servers

require("mason").setup({
	ui = {
		border = "rounded",
		icons = { package_installed = "✓", package_pending = "⟳", package_uninstalled = "-" },
	},
})

require("mason-lspconfig").setup({ automatic_installation = true, ensure_installed = vim.tbl_keys(servers) })

for server, config in pairs(servers) do
	local opts = utils.tbl_extend_force(options, config or {})
	lspconfig[server].setup(opts)
end
