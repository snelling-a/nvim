local args = {
	"--codes",
	"--no-color",
	"--formatter=plain",
	"-",
}

local M = {}

M.mason_name = "luacheck"

M.config = {
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	lintStdin = true,
	prefix = M.mason_name,
	lintSource = "luacheck",
}

return M
