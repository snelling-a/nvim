local M = {}

M.mason_name = "vint"

local args = {
	"--format",
	"--no-color",
	"--warning",
	"{file_path}:{line_number}:{column_number}:",
	"{severity}:",
	"{description}",
	"(see",
	"{reference})",
}

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		lintCommand = command,
		lintStdin = false,
		lintFormats = {
			"%f:%l:%c: %trror: %m",
			"%f:%l:%c: %tarning: %m",
		},
		rootMarkers = {
			".vintrc.yaml",
			".vintrc.yml",
			".vintrc",
		},
	}
end

return M
