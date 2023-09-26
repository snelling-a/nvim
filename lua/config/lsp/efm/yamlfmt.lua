local args = {
	"-",
}

local M = {}

M.mason_name = "yamlfmt"

M.config = {
	prefix = M.mason_name,
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintStdin = true,
	rootMarkers = {
		".yamlfmt",
	},
}

return M
