local M = {}

M.mason_name = "graphql-language-service-cli"

function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern({
		".graphqlrc*",
		".graphql.config.*",
		"graphql.config.*",
	})

	require("lspconfig").graphql.setup(opts)
end

return M
