local config_files = {
	"taplo.toml",
	".taplo.toml",
}

local settings = {
	evenBetterToml = {
		schema = {
			repositoryEnabled = true,
		},
	},
}

local Taplo = {}

function Taplo.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	opts.settings = settings

	require("lspconfig").taplo.setup(opts)
end

return Taplo
