local util = require("config.util")

local M = {}

function M.setup(opts)
	--Enable (broadcasting) snippet capability for completion
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	opts.capabilities = util.tbl_extend_force(opts.capabilities or {}, capabilities)

	require("lspconfig").cssls.setup(opts)
end

return M
