local args = {
	"--codes",
	"--no-color",
	"--quiet",
	"-",
}

local M = {}

M.mason_name = "luacheck"

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		lintIgnoreExitCode = true,
		lintStdin = true,
		lintFormats = {
			"%.%#:%l:%c: (%t%n) %m",
		},
		rootMarkers = {
			".luacheckrc",
		},
	}
end

return M
