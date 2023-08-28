local M = {}

M.mason_name = ""

function M.setup(opts)
	if not vim.fn.executable("relay") then
		os.execute("npm install -g relay-compiler")
	end

	opts.root_dir = require("config.lsp.util").get_graphql_root_pattern()

	require("lspconfig").relay_lsp.setup(opts)
end

return M
