local Eslint = {}

Eslint.mason_name = "eslint-lsp"

Eslint.config_files = {
	".eslintrc",
	".eslintrc.cjs",
	".eslintrc.js",
	".eslintrc.json",
	".eslintrc.yaml",
	".eslintrc.yml",
	"package.json",
}

function Eslint.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(Eslint.config_files)

	require("lspconfig").eslint.setup(opts)
end

return Eslint
