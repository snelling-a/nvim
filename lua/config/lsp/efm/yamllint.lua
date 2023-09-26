local args = {
	"-f",
	"parseable",
	"-",
}

local M = {}

M.mason_name = "yamllint"

M.config = {
	prefix = M.mason_name,
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintStdin = true,
	rootMarkers = {
		".yamllint",
		".yamllint.yaml",
		".yamllint.yml",
	},
}

return M
