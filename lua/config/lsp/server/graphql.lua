local M = {}

M.mason_name = "graphql-language-service-cli"

function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_graphql_root_pattern()

	require("lspconfig").graphql.setup(opts)
end

return M
