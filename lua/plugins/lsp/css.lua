---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = function(_, opts)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	---@diagnostic disable-next-line: inject-field
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	return require("util").tbl_extend_force(opts, {
		servers = {
			cssls = {
				settings = {
					css = { validate = true },
					less = { validate = true },
					scss = { validate = true },
				},
				capabilities = capabilities,
			},
		},
	})
end

local languge_setup = require("lsp").util.setup_language({
	ts = { "css", "scss" },
	langs = { "css" },
	formatters = { "prettierd" },
	linters = { "stylelint" },
})

return {
	M,
	unpack(languge_setup),
}
