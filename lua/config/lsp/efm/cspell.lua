local args = {
	"lint",
	"--no-color",
	"--no-progress",
	"--no-summary",
}

local M = {}

M.mason_name = "cspell"

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		lintFormats = {
			"%f:%l:%c:%trror - %m",
			"%f:%l:%c %m",
		},
		rootMarkers = {
			"package.json",
			".cspell.json",
			"cspell.json",
			".cSpell.json",
			"cSpell.json",
			"cspell.config.js",
			"cspell.config.cjs",
			"cspell.config.json",
			"cspell.config.yaml",
			"cspell.config.yml",
			"cspell.yaml",
			"cspell.yml",
		},
	}
end

return M
