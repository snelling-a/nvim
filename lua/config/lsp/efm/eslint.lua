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
}

local M = {}

M.mason_name = "eslint_d"

function M.setup()
	return {
		lintCommand = command(M.mason_name, linter_args),
		lintStdin = true,
		lintFormats = {
			"%f:%l:%c: %m",
		},
		lintIgnoreExitCode = true,
		formatCommand = command(M.mason_name, formatter_args),
		formatStdin = true,
		rootMarkers = require("config.lsp.server.eslint").config_files,
	}
end

return M
