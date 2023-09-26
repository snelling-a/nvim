local args = {
	"-filename",
	"${INPUT}",
	"-",
}

local M = {}

M.mason_name = "shfmt"

M.config = {
	formatCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	formatStdin = true,
}

return M
