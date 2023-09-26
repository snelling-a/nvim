local args = {
	"lint",
	"--no-color",
	"--no-progress",
	"--no-summary",
	'"${INPUT}"',
}

local M = {}

M.mason_name = "cspell"

M.config = {
	lintCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	lintFormats = { "%f:%l:%c:%trror - %m", "%f:%l:%c %m" },
	lintSeverity = 3,
	lintSource = ("efm/%s"):format(M.mason_name),
	prefix = M.mason_name,
}

return M
