local M = {}

M.mason_name = "shellcheck"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, {
	"--color=never",
	"--format=gcc",
	"-",
})

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = command,
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
