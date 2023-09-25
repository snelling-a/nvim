local config_files = {
	"taplo.toml",
	".taplo.toml",
	"*.toml",
}

local settings = {
	evenBetterToml = {
		schema = {
			enabled = true,
			repositoryEnabled = true,
		},
	},
}

local M = {}

--- @param opts lspconfig.Config
function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	opts.settings = settings

	require("lspconfig").taplo.setup(opts)
end

return M
