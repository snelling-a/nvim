local args = {
	"--color=never",
	"--format=gcc",
	"--external-sources",
	"-",
}

local M = {}

M.mason_name = "shellcheck"

M.config = {
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintSource = "shellcheck",
	lintStdin = true,
	prefix = M.mason_name,
    lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
}

return M
