local M = {}

M.mason_name = "luacheck"

local args = { "--codes", "--no-color", "--quiet", "-" }
local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = command,
		lintIgnoreExitCode = true,
		lintStdin = true,
		lintFormats = { "%.%#:%l:%c: (%t%n) %m" },
		rootMarkers = { ".luacheckrc" },
	}
end

return M
