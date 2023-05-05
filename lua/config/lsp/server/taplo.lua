local lspconfig = require("lspconfig")

local settings = { evenBetterToml = { schema = { repositoryEnabled = true } } }

local M = {}

function M.setup(opts)
	opts.root_dir = lspconfig.util.root_pattern("*.toml")

	opts.settings = settings

	lspconfig.taplo.setup(opts)
end

return M
