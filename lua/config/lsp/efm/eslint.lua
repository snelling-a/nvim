local get_format_command = require("config.lsp.util").get_linter_formatter_command
local M = {}

M.mason_name = "eslint_d"

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
}

local format_command = get_format_command(M.mason_name, formatter_args)

local lint_command = get_format_command(M.mason_name, linter_args)

function M.setup()
	return {
		lintCommand = lint_command,
		lintStdin = true,
		lintFormats = { "%f:%l:%c: %m" },
		lintIgnoreExitCode = true,
		formatCommand = format_command,
		formatStdin = true,
		rootMarkers = require("config.lsp.server.eslint").config_files,
	}
end

return M
