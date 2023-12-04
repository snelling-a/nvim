---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = function(_, opts)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	---@diagnostic disable-next-line: inject-field
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	return require("util").tbl_extend_force(opts, {
		servers = {
			html = {
				settings = { provideFormatter = false },
				capabilities = capabilities,
			},
			emmet_ls = {},
		},
	})
end

local languge_setup = require("lsp").util.setup_language({
	langs = { "html" },
	formatters = { "prettierd" },
})

return {
	M,
	unpack(languge_setup),
}
