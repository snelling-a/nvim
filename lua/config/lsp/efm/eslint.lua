local command = require("config.lsp.util").get_linter_formatter_command

local formatter_args = {
	"--no-color",
	"--fix-to-stdout",
	"--stdin",
	"--stdin-filename",
	"${INPUT}",
}

local linter_args = {
	"--no-color",
	"--format",
	"visualstudio",
	"--stdin",
	"--stdin-filename",
	"${INPUT}",
}

local M = {}

M.mason_name = "eslint_d"

M.config = {
	formatCommand = command(M.mason_name, formatter_args),
	formatStdin = true,
	lintCommand = command(M.mason_name, linter_args),
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	lintSource = "eslint",
	lintStdin = true,
	rootMarkers = { "package.json" },
}

return M
