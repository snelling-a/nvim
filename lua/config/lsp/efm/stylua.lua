local args = {
	"--search-parent-directories",
	"--color",
	"Never",
	"-",
}

local M = {}

M.mason_name = "stylua"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

M.config = {
	formatCommand = command,
	formatCanRange = true,
	formatStdin = true,
	rootMarkers = {
		"stylua.toml",
		".stylua.toml",
	},
}

return M
