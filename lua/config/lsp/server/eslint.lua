local M = {}

M.mason_name = "eslint-lsp"

M.config_files = {
	".eslintrc",
	".eslintrc.cjs",
	".eslintrc.js",
	".eslintrc.json",
	".eslintrc.yaml",
	".eslintrc.yml",
	"package.json",
}

function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(M.config_files)

	require("lspconfig").eslint.setup(opts)
end

return M
