local args = {
	"--no-color",
	"--warning",
}

local M = {}

M.mason_name = "vint"

M.config = {
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", },
	lintStdin = false,
}

return M
