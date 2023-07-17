local GraphQL = {}

GraphQL.mason_name = "graphql-language-service-cli"

function GraphQL.setup(opts)
	opts.root_dir = require("config.lsp.util").get_graphql_root_pattern()

	require("lspconfig").graphql.setup(opts)
end

return GraphQL
