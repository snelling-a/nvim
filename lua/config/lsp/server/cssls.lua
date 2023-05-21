local M = {}

function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	require("lspconfig").cssls.setup(opts)
end

return M
