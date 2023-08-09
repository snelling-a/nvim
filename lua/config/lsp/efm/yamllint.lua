local M = {}

M.mason_name = "yamllint"

local args = {
	"-f",
	"parseable",
	"-",
}

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = command,
		lintStdin = true,
		rootMarkers = {
			".yamllint",
			".yamllint.yaml",
			".yamllint.yml",
		},
	}
end

return M
