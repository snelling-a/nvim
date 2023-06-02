local util = require("config.lsp.util")

local config_files = {
	".eslintrc",
	".eslintrc.cjs",
	".eslintrc.js",
	".eslintrc.json",
	".eslintrc.yaml",
	".eslintrc.yml",
	"package.json",
}

local Eslint = {}

function Eslint.setup(opts)
	opts.root_dir = util.get_root_pattern(config_files)

	require("lspconfig").eslint.setup(opts)
end

return Eslint
