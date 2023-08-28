local M = {}

M.mason_name = "css-lsp"

function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	require("lspconfig").cssls.setup(opts)
end

return M
