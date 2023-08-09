local M = {}

M.mason_name = "prettierd"

local args = {
	"${INPUT}",
	"${--range-start=charStart}",
	"${--range-end=charEnd}",
	"${--tab-width=tabSize}",
	"${--use-tabs=!insertSpaces}",
}

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		formatCommand = command,
		formatCanRange = true,
		formatStdin = true,
		rootMarkers = {
			".prettierrc",
			".prettierrc.cjs",
			".prettierrc.js",
			".prettierrc.json",
			".prettierrc.json5",
			".prettierrc.mjs",
			".prettierrc.toml",
			".prettierrc.yaml",
			".prettierrc.yml",
			"prettier.config.cjs",
			"prettier.config.js",
		},
	}
end

return M
