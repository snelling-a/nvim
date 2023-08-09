local M = {}

M.mason_name = "stylua"

local args = {
	"${--indent-width:tabSize}",
	"${--range-start:charStart}",
	"${--range-end:charEnd}",
	"--color",
	"Never",
	"-",
}

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		formatCommand = command,
		formatCanRange = true,
		formatStdin = true,
		rootMarkers = {
			"stylua.toml",
			".stylua.toml",
		},
	}
end

return M
