local args = {
	".",
}

local M = {}

M.mason_name = "jq"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

M.config = {
	formatCommand = command,
	formatStdin = true,
	lintCommand = command,
	lintFormats = { "parse error: %m at line %l, column %c" },
	lintIgnoreExitCode = true,
	lintSource = "jq",
	lintStdin = true,
	prefix = M.mason_name,
}

return M
