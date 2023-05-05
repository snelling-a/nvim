local util = require("config.lsp.util")

local M = {}

function M.setup(opts)
	opts.root_dir = util.get_graphql_root_pattern()

	require("lspconfig").relay_lsp.setup(opts)
end

return M
