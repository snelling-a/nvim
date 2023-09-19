local args = {
	"--color=never",
	"--format=gcc",
	"--external-sources",
	"-",
}

local M = {}

M.mason_name = "shellcheck"

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		lintStdin = true,
		lintFormats = {
			"-:%l:%c: %trror: %m",
			"-:%l:%c: %tarning: %m",
			"-:%l:%c: %tote: %m",
		},
		rootMarkers = {},
	}
end

return M
